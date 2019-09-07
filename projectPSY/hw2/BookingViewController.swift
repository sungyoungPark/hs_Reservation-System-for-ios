//
//  ViewController.swift
//  hw2Leejaemoon
//
//  Created by Jae Moon Lee on 16/04/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import UIKit

protocol UpdateDelegate4: NSObjectProtocol {
    func updateChanged()
}

class BookingViewController: UIViewController, DatabaseDelegate {
    
    var userGroup: String!
    var userName: String! 
    var uiTimer: Timer?
    var databaseBroker: DatabaseBroker?
    var databaseObject: DatabaseObject?
    var maxSlots = 50
    var bookingDatabase = [String](repeating: "", count: 50)  //배열 50개로 초기화하여 시작
    var settingDatabase = Setting()
    var innerStackViews = [UIStackView]()
    var flag: Int = 2
    var row_stack: Int = 25
    var updateDelegate4: UpdateDelegate!
    var rootPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //databaseBroker?.loadBookingDatabase(userGroup: userGroup)
        f1()
        if UIDevice.current.orientation.isPortrait {
            drawBase()
        }else{
            
            drawBase()
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateDrawingTimer.invalidate()
        if let delegate = updateDelegate4 {
            delegate.updateChanged()
        }
    }
    
    var updateDrawingTimer: Timer!
    
    override func viewDidAppear(_ animated: Bool) {
        title = "부킹:" + userGroup
        updateDrawingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(drawBookingOnBase), userInfo: nil, repeats: true)
        
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        if UIDevice.current.orientation.isLandscape {
            flag=4
            row_stack=13
            print("Landscape1")
            drawBase()
        }
        else {
            flag=2
            row_stack=25
            print("Portrait1")
            drawBase()
        }
    }
    
    
    func drawBase(){
        
        let baseStackView = UIStackView()
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical
        baseStackView.alignment = .fill
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 2
        
        view.addSubview(baseStackView)
        baseStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        baseStackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10).isActive = true
        baseStackView.topAnchor.constraint(equalTo: view.topAnchor ,constant: 40).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -40).isActive = true
        
        for i in 0..<row_stack{
            let outerStackView = UIStackView()
            outerStackView.axis = .horizontal
            outerStackView.alignment = .fill
            outerStackView.distribution = .fillEqually
            outerStackView.spacing = 5
            baseStackView.addArrangedSubview(outerStackView)
            
            outerStackView.leftAnchor.constraint(equalTo: baseStackView.leftAnchor).isActive = true
            outerStackView.rightAnchor.constraint(equalTo: baseStackView.rightAnchor).isActive = true
            
            for j in 0..<flag {
                let time = i*60*(flag/2)+j*30
                
                let innerStackView = UIStackView()
                innerStackView.axis = .horizontal
                innerStackView.distribution = .fill
                innerStackView.spacing = 1
                outerStackView.addArrangedSubview(innerStackView)
                
                let leftLabel = UILabel()
                if time/60<25
                {
                    leftLabel.text = String.init(format: "%02d시%02d분", time/60 , time%60)    //라벨에 시간 넣기
                    leftLabel.textAlignment = .center
                    leftLabel.layer.borderColor = UIColor.black.cgColor
                    leftLabel.layer.borderWidth = 1.0
                    leftLabel.isUserInteractionEnabled = true
                    innerStackView.addArrangedSubview(leftLabel)
                    leftLabel.widthAnchor.constraint(equalTo: innerStackView.widthAnchor, multiplier: 0.45, constant: 0).isActive = true
                    
                    let rightLabel = UILabel()
                    //print(bookingDatabase)
                    if bookingDatabase[time/30].isEmpty
                    {
                        rightLabel.text = ""
                    }
                    else{
                        rightLabel.text = bookingDatabase[time/30]
                        
                    }
                    
                    rightLabel.textAlignment = .center
                    rightLabel.layer.borderColor = UIColor.black.cgColor
                    rightLabel.layer.borderWidth = 1.0
                    rightLabel.isUserInteractionEnabled = true
                    innerStackView.addArrangedSubview(rightLabel)
                    
                    let cal = Calendar.current
                    let date = Date()
                    let currentHour = cal.component(.hour, from:date)
                    let currenMinute = cal.component(.minute, from: date)
                    //라벨에 색 넣기
                    
                    if time/60-currentHour>0 {
                        leftLabel.backgroundColor = UIColor.white
                        rightLabel.backgroundColor = UIColor.white
                    }
                    else if time/60-currentHour==0 && currenMinute-time%60*30<30
                    {
                        leftLabel.backgroundColor = UIColor.white
                        rightLabel.backgroundColor = UIColor.white
                    }
                    else{
                        leftLabel.backgroundColor = UIColor.gray
                        rightLabel.backgroundColor = UIColor.gray
                    }
                    
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
                    
                    innerStackView.addGestureRecognizer(tapGestureRecognizer)
                    innerStackViews.append(innerStackView)
                }
                
            }
        }
    }
    
    @objc
    func tapHandler( sender: UITapGestureRecognizer){
        let innerStackView1 = sender.view as! UIStackView
        let outerView1 = innerStackView1.superview
        let baseView1 = outerView1?.superview
        let index1: Int = (baseView1?.subviews.index(of: outerView1!))!
        let index2: Int = (outerView1?.subviews.index(of: innerStackView1))!
        let message = (innerStackView1.subviews[0] as! UILabel).text!
        
        let rightLabel = innerStackView1.subviews[0] as! UILabel
        let rightLabel_text = innerStackView1.subviews[1] as! UILabel
        if rightLabel.backgroundColor == UIColor.white {   //예약 가능시간이면
            if rightLabel_text.text == userName{    //예약 취소
                rightLabel_text.text = ""
                print(flag*index1+index2)
                bookingDatabase[flag*index1+index2] = ""
                databaseBroker?.saveBookingDatabase(userGroup: userGroup, bookingDatabase: bookingDatabase)
                
                settingDatabase.maxTotalBookingSlots=settingDatabase.maxTotalBookingSlots+1
                databaseBroker?.saveSettingDatabase(settingDatabase: settingDatabase)
                
                Message.information(parent: self, title: "알림", message: "예약이 취소 되었습니다.")
            }
            else if rightLabel_text.text!.isEmpty   //예약이 가능할때
            {
                if settingDatabase.maxTotalBookingSlots != 0{
                    if !checkContinueBooking(index: flag*index1+index2){
                        Message.information(parent: self, title: "예약불가", message: "최대 예약 시간 초과")
                    }
                    else{
                        rightLabel_text.text = userName
                        bookingDatabase[flag*index1+index2] = userName  //bookingDatabase에 userName 넣기
                        databaseBroker?.saveBookingDatabase(userGroup: userGroup, bookingDatabase: bookingDatabase)
                        settingDatabase.maxTotalBookingSlots=settingDatabase.maxTotalBookingSlots-1   //최대 예약 개수 마이너스
                        databaseBroker?.saveSettingDatabase(settingDatabase: settingDatabase)
                        Message.information(parent: self, title: "알림", message: "예약 되었습니다.")
                    }
                    
                }
                else{
                    Message.information(parent: self, title: "예약불가", message: "하루 최대 예약 횟수 초과")
                }
            }
            else{  //다른 사람이 예약을 하였을때
                Message.information(parent: self, title: "알림", message: "이미 예약이 있습니다.")
            }
            
        }
        
    }
    
    let colors = [UIColor.white, UIColor.gray]
    var colorIndex = 0
    var count = 0
    
    @objc
    func drawBookingOnBase(){
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        drawBase()
        
        //  let cal = Calendar.current
        //  let date = Date()
        //  let currentHour = cal.component(.hour, from:date)
        //  let currenMinute = cal.component(.minute, from: date)
        
        // for i in 0..<maxSlots {
        //     let leftLabel = innerStackViews[i].subviews[0] as! UILabel
        //     if currentHour<i*30
        // }
        
    }
    
    
    func f1(){
        print("f1")
        print(rootPath)
        databaseBroker = DatabaseObject.createDatabase(rootPath: rootPath)
        databaseBroker?.setSettingDataDelegate(dataDelegate: self)
        databaseBroker?.setBookingDataDelegate(userGroup: userGroup, dataDelegate: self)
    }
    
    
    func checkContinueBooking(index: Int) ->Bool{
        
        if index + 2 <= 49 && index-2 >= 0 && bookingDatabase[index-1] == userName && bookingDatabase[index+1] == userName {
            return false
        }
        else if index-2 >= 0 && bookingDatabase[index-2] == userName && bookingDatabase[index-1] == userName{
            return false
        }
        else if index+2 <= 49 && bookingDatabase[index+2] == userName && bookingDatabase[index+1] == userName{
            return false
        }
        else{
            return true
        }
        
    }
    
    
    /*
     func onChange(userDatabaseStr: String) {
     
     }
     
     func onChange(databaseRootStr: String) {

     }
     
     func onChange(groupDatabaseStr: String) {
        groupDatabase = databaseBroker!.loadGroupDatabase()
     }
 */
    func onChange(bookingDatabaseStr: String) {
        print("load onchange")
        bookingDatabase = databaseBroker!.loadBookingDatabase(userGroup: userGroup)
    }
    
    func onChange(settingDatabaseStr: String) {
        settingDatabase = databaseBroker!.loadSettingDatabase()
        print("setting onchange")
        
    }
    
}


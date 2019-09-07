//
//  ManagingSettingsViewController.swift
//  hw3ManagerPSY
//
//  Created by psy on 20/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

class ManagingSettingViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,DatabaseDelegate {
    
    var databaseBroker: DatabaseBroker?
    var dataBaseObject: DatabaseObject?
    var picker_Selected=0
    var timer: [String] = []
    var setting = Setting()
    var rootPath = ""
    @IBOutlet weak var firstPickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        f3()
        print("f3끝")
        print(rootPath)
        if UIApplication.shared.statusBarOrientation.isPortrait{
            mainStackView.axis = .vertical  //화면 orientation에 따라 변경
            print("Portrait1")
            
        }else{
            mainStackView.axis = .horizontal
           print("Land scape")
        }
        
        print("배열 생성") //pickerview에 보여줄 시간 생성
        for i in 0..<22{
            var str: String
            str=String.init(format: "%02d시 %02d분", i/2,i%2*30)
            print(str)
            timer.append(str)
            }
        firstPickerView.delegate = self
        secondPickerView.delegate = self
        firstPickerView.dataSource = self
        secondPickerView.dataSource = self
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape1")
            mainStackView.axis = .horizontal
        }
        else {
            print("Portrait1")
            mainStackView.axis = .vertical
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        f3()
       // setting = databaseBroker?.loadSettingDatabase()!
        print(setting.maxContinueBookingSlots)
        print(setting.maxTotalBookingSlots)
        firstPickerView.selectRow(setting.maxContinueBookingSlots, inComponent: 0, animated: false)
        secondPickerView.selectRow(setting.maxTotalBookingSlots, inComponent: 0, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setting.maxContinueBookingSlots = firstPickerView.selectedRow(inComponent: 0)  //첫번째
        setting.maxTotalBookingSlots = secondPickerView.selectedRow(inComponent: 0)//두번째
        if(setting.maxContinueBookingSlots>setting.maxTotalBookingSlots){
            Message.information(parent: self, title: "경고", message: "셋팅 설정 오류 저장 안됨")
        }  //제약조건을 해결하지 않고 다른 뷰로 가면 저장을 시키지 않음
        else{
            print(setting.maxContinueBookingSlots)
            print(setting.maxTotalBookingSlots)
            databaseBroker?.saveSettingDatabase(settingDatabase: setting)
            }
    }
        // Do any additional setup after loading the view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("first")
        print(setting.maxContinueBookingSlots)
        print("second")
        print(setting.maxTotalBookingSlots)
        print("row")
        print(row)
        if(firstPickerView.selectedRow(inComponent: 0) > secondPickerView.selectedRow(inComponent: 0)){
            Message.information(parent: self, title: "경고", message: "셋팅 설정 오류")
            return timer[row]
        } //셋팅 시간 설정 오류 일때(제약조건)
        else{
        return timer[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        picker_Selected = row
    }
    
    func f3(){
        print("f3")
        databaseBroker = DatabaseObject.createDatabase(rootPath: rootPath)
        databaseBroker?.setSettingDataDelegate(dataDelegate: self)
        //databaseBroker?.setGroupDataDelegate(dataDelegate: self)
        //databaseBroker?.setUserDataDelegate(dataDelegate: self)
    }
    
    func onChange(settingDatabaseStr: String) {
        setting = databaseBroker!.loadSettingDatabase()
    }
    @IBAction func dissmissView(_ sender: Any) {  //메인화면으로
        print("뒤로가기")
        navigationController?.dismiss(animated: false, completion: nil)
        
    }
}

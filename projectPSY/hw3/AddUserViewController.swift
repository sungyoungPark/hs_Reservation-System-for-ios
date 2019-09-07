//
//  AddUserViewController.swift
//  hw3ManagerPSY
//
//  Created by psy on 27/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

protocol UpdateDelegate2: NSObjectProtocol {
    func updateChanged()
}

class AddUserViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, DatabaseDelegate { //유저를 추가하는 컨트롤러
   
    var updateDelegate2: UpdateDelegate!
    var databaseBroker: DatabaseBroker!{
        didSet{
            
        }
    }
    
    var groupDatabase: [String]! {
        didSet{
            
        }
    }

    var userDatabase:[User]! {
        didSet{
            
        }
    }
    
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func onChange(groupDatabaseStr: String) {
        groupDatabase = databaseBroker.loadGroupDatabase()
        groupPickerView.reloadComponent(0)
    }
    //pickerview 생성
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupDatabase.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupDatabase[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picker_Selected=row
    }
    
    @IBAction func cancelUser(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    
    var arr: [String] = []
    var picker_Selected=0
 
    
    @IBOutlet var userIdLabel: UITextField!
    @IBOutlet weak var userPwdLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("생성")
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
        print("생성2")
    }
    
    @IBAction func addUser(_ sender: UIButton) {  //확인 버튼 누르면
        var userGroup = groupDatabase[groupPickerView.selectedRow(inComponent: 0)]
        
        for i in 0..<userDatabase.count{
            if userIdLabel.text == userDatabase[i].name{
                Message.information(parent: self, title: "오류", message: "이미 있는 사용자입니다.")
                break
            }
            if i == userDatabase.count-1{
                print("저장 성공")
                var newUser = User(name: userIdLabel.text!,password: userPwdLabel.text!,group: userGroup)
                userDatabase.append(newUser)
                databaseBroker.saveUserDatabase(userDatabase:userDatabase)  //바꾼 userDatabase를 저장
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate2 = updateDelegate2 {
            delegate2.updateChanged()
        }
    }
    
    
}

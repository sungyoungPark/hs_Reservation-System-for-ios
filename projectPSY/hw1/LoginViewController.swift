//
//  ViewController.swift
//  hw1LoginHonggildong
//
//  Created by Jae Moon Lee on 25/02/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, DatabaseDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupDatabase.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if groupDatabase.count > row {
            return groupDatabase[row]
        }else{
            return nil
        }
    }
    
    func onChange(groupDatabaseStr: String) {
        groupDatabase = databaseBroker!.loadGroupDatabase()
        
        userGroupPicker.reloadComponent(0)
        okButton.isEnabled = true
        changePasswordButton.isEnabled = true
    }
    
    func onChange(userDatabaseStr: String) {
        userDatabase = databaseBroker!.loadUserDatabase()
    }
    
    
    @IBOutlet var userTypeSwitch: UISwitch!
    @IBOutlet var userGroupPicker: UIPickerView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userPasswordTextField: UITextField!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var changePasswordButton: UIButton!
    var selectedUserGroup = 0
    var dataBaseObject: DatabaseObject?
    var preferences : Preferences = Preferences()
    var databaseBroker : DatabaseBroker?
    var rootdatabaseBroker : DatabaseBroker?
    var groupDatabase = [String]()
    var userDatabase = [User]()
    var tapGestureRecognizer: UITapGestureRecognizer?
    var rootPath = "honggildong"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferences = Preferences()
        print(rootPath)
        databaseBroker = DatabaseObject.createDatabase(rootPath: rootPath)
        rootdatabaseBroker = DatabaseObject.createDatabase(rootPath: "test")
        databaseBroker!.setGroupDataDelegate(dataDelegate: self)
        databaseBroker!.setUserDataDelegate(dataDelegate: self)
        
        rootdatabaseBroker!.setGroupDataDelegate(dataDelegate: self)
        rootdatabaseBroker!.setUserDataDelegate(dataDelegate: self)
        preferences.userName = ""
        userDatabase = databaseBroker!.loadUserDatabase()
        groupDatabase = databaseBroker!.loadGroupDatabase()
        rootdatabaseBroker!.saveUserDatabase(userDatabase: userDatabase)
        rootdatabaseBroker!.saveGroupDatabase(groupDatabase: groupDatabase)
        print("viewDidLoad")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler));
        tapGestureRecognizer.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @IBAction func onPickerValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            userNameTextField.text = "root"
            userNameTextField.isEnabled = false
            userPasswordTextField.text = ""
        }else{
            userNameTextField.isEnabled = true
            if preferences.userName != ""{
            print("텅텅")
            userNameTextField.text = preferences.userName
            userPasswordTextField.text = preferences.userPassword
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupDatabase = databaseBroker!.loadGroupDatabase()
       // userDatabase = rootdatabaseBroker!.loadUserDatabase()
        //databaseBroker!.saveUserDatabase(userDatabase: rootdatabaseBroker?.loadUserDatabase())
    
       // print("viewWillAppear",groupDatabase)
    print("willappear",rootdatabaseBroker!.loadUserDatabase())
    }
    
    var testCount:Int = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DatabaseObject.rootPath = preferences.rootPath
        
        title = "공유시설예약:" + rootPath
        print("checkpoint")
        print(preferences.userName)
        okButton.isEnabled = true
        changePasswordButton.isEnabled = true
        userTypeSwitch.isOn = true
        userNameTextField.text = "root"
        userNameTextField.isEnabled = false
        
        userGroupPicker.delegate = self
        userGroupPicker.dataSource = self

        
        /*
        if preferences.userType == 0 {
            userRadioButton.isOn = true
            managerRadioButton.isOn = false
        }else{
            userRadioButton.isOn = false
            managerRadioButton.isOn = true
        }
 
        selectedUserGroup = preferences.userGroup
        userNameTextField.text = preferences.userName
        
        userPasswordTextField.text = ""
        if preferences.userName != "root" {
            userPasswordTextField.text = preferences.userPassword
        }
        */
    }
    
    @objc func tapHandler(sender: UITapGestureRecognizer){
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        //groupComboBox.setHidden(isHidden: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        /*
        if(userRadioButton.isOn){
            preferences.userType = 0
        }else{
            preferences.userType = 1
        }
        preferences.userGroup = groupComboBox.getSelectedRow()
 
        preferences.userName = userNameTextField.text!
        preferences.userPassword = userPasswordTextField.text!
        Preferences.savePreferences(preferences: preferences)
        */
    }
    
    func checkUser(name: String, password: String, group: String) -> Bool {
        userDatabase = databaseBroker!.loadUserDatabase()
        var usersWithName = [User]()
        for user in userDatabase {
            if user.isMe(name: name){
                usersWithName.append(user)
            }
        }
        if usersWithName.count == 0 {
            Message.information(parent: self, title: "경고", message: "등록되지 않은 사용자입니다.")
            return false
        }
        
        var usersWithPassword = [User]()
        for user in usersWithName {
            if user.isMe(password: password){
                usersWithPassword.append(user)
            }
        }
        if usersWithPassword.count == 0 {
            Message.information(parent: self, title: "경고", message: "비밀번호가 틀렸습니다.")
            return false
        }
        
        if name == "root"{
            return true
        }
        
        var usersWithGroup = [User]()
        for user in usersWithPassword {
            if user.isMe(group: group){
                usersWithGroup.append(user)
            }
        }
        if usersWithGroup.count == 0 {
            Message.information(parent: self, title: "경고", message: "소속 그룹이 틀렸습니다.")
            return false
        }
        return true
    }
    
    
    @IBAction func onChnagePasswordClicked(_ sender: Any) {
        Message.information(parent: self, title: "알림", message: "아직 구현이 안 되었습니다.")
        /*
        let userName = userNameTextField.text!
        if userName == "" {
            Message.information(parent: self, title: "경고", message: "아이디를 입력하세요")
            return
        }
        let userPassword = userPasswordTextField.text!
        let userGroup = groupDatabase[groupComboBox.getSelectedRow()]
        
        
        if !checkUser(name: userName, password: userPassword, group: userGroup){
            return
        }
        self.performSegue(withIdentifier: "loginToPassword", sender: self)
        */
    }
    
    @IBAction func onOkClicked(_ sender: Any) {
        let userName = userNameTextField.text!
        if userName == "" {
            Message.information(parent: self, title: "경고", message: "아이디를 입력하세요")
            return
        }
        let userPassword = userPasswordTextField.text!
        let userGroup = groupDatabase[userGroupPicker.selectedRow(inComponent: 0)]
        
        if !checkUser(name: userName, password: userPassword, group: userGroup){
            return
        }
        if userName == "root"{
        self.performSegue(withIdentifier: "managingView", sender: self)
       // Message.information(parent: self, title: "알림", message: "로그인 되었습니다.")
        }
        else{
            //prefernece에 저장
            preferences.userName = userName
            preferences.userPassword = userPassword
            preferences.userGroup = userGroupPicker.selectedRow(inComponent: 0)
            self.performSegue(withIdentifier: "bookingView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookingView"{
            let addGroupViewController = segue.destination as! BookingViewController
            addGroupViewController.databaseBroker = databaseBroker
            addGroupViewController.databaseObject = dataBaseObject
            addGroupViewController.rootPath = rootPath
            addGroupViewController.userName = userNameTextField.text!
            addGroupViewController.userGroup = groupDatabase[userGroupPicker.selectedRow(inComponent: 0)]
        }
        if segue.identifier == "managingView"{
            let tabBarController = segue.destination as! UITabBarController
            let NavigationController = tabBarController.viewControllers![0] as! UINavigationController
            let mannagingController = NavigationController.topViewController as! ManagingGroupViewController
            mannagingController.databaseBroker = databaseBroker
            mannagingController.groupDatabase = groupDatabase
            mannagingController.rootPath = rootPath
            
            let NavigationController1 = tabBarController.viewControllers![1] as! UINavigationController
            let managingUserController = NavigationController1.topViewController as! ManagingUserViewController
            managingUserController.databaseBroker = databaseBroker
            managingUserController.groupDatabase = groupDatabase
            managingUserController.rootPath = rootPath
            
            
            let NavigationController2 = tabBarController.viewControllers![2] as! UINavigationController
            let managingSettionController = NavigationController2.topViewController as! ManagingSettingViewController
            managingSettionController.databaseBroker = databaseBroker
            //managingSettionController.groupDatabase = groupDatabase
            managingSettionController.rootPath = rootPath
            
        }
    }

    
    @IBAction func onCancelClicked(_ sender: Any) {
        
        /*
        let preferences = Preferences()
        
        if(userRadioButton.isOn){
            preferences.userType = 0
        }else{
            preferences.userType = 1
        }
 
        preferences.userGroup = groupComboBox.getSelectedRow()
        preferences.userName = userNameTextField.text!
        preferences.userPassword = userPasswordTextField.text!
        Preferences.savePreferences(preferences: preferences)
        */
        
        if self.navigationController?.parent != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    /*
    @IBAction func onUserRadioButtonClicked(_ sender: HsRadioButton) {
        userRadioButton.isOn = true
        managerRadioButton.isOn = false
        userNameTextField.isEnabled = true
        
    }
    
    @IBAction func onManagerRadioButtonClicked(_ sender: HsRadioButton) {
        managerRadioButton.isOn = true
        userRadioButton.isOn = false
        userNameTextField.text = "root"
        userNameTextField.isEnabled = false
        userPasswordTextField.text = ""
        
    }
    */
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginToUser" {
            
            let navigationViewController = segue.destination as! UINavigationController
            let userBookingViewController = navigationViewController.viewControllers[0] as! UserBookingViewController
            userBookingViewController.userName = userNameTextField.text
            userBookingViewController.userGroup = groupComboBox.getSelectedItem()
            
            
        }else if segue.identifier == "loginToPassword"{
            let navigationViewController = segue.destination as! UINavigationController
            let changePasswordViewController = navigationViewController.viewControllers[0] as! ChangePasswordViewController
            changePasswordViewController.userName = userNameTextField.text
            changePasswordViewController.userGroup = groupComboBox.getSelectedItem()
        }
 
    }
    */
}


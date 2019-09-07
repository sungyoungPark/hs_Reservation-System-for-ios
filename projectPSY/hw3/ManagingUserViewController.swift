//
//  ManagingUserViewController.swift
//  hw3ManagerPSY
//
//  Created by psy on 20/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

class DetailDelegate2: NSObject, UpdateDelegate{
    var tableView: UITableView
    init(_ tableView: UITableView){
        self.tableView = tableView
    }
    func updateChanged() {
        tableView.reloadData()
    }
}

class ManagingUserViewController: UITableViewController,DatabaseDelegate  {
    
    var databaseBroker: DatabaseBroker?
    var databaseObject: DatabaseObject?
    var groupDatabase = [String]()
    var userDatabase:[User] = []
    var arr: [String] = []
    var rootPath = ""

  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("지나감")
        print(rootPath)
        tableView.setEditing(true, animated: true)
        self.tableView.rowHeight = 44
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dissmissView(_ sender: Any) {
        //메인화면으로
        databaseBroker?.saveUserDatabase(userDatabase: userDatabase)
        print("뒤로가기")
        navigationController?.dismiss(animated: false, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {  //화면 다시 생성되면 데이터베이스 다시 연결
        print("다시 출력")
        f2()
       //groupDatabase = databaseBroker!.loadGroupDatabase()
        //print(groupDatabase)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        f2()
        groupDatabase = databaseBroker!.loadGroupDatabase()
        userDatabase = databaseBroker!.loadUserDatabase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //databaseBroker!.saveUserDatabase(userDatabase: userDatabase)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "CreateUser"){
            let addUserViewController = segue.destination as! AddUserViewController
            addUserViewController.groupDatabase = groupDatabase
            addUserViewController.userDatabase = userDatabase
            addUserViewController.databaseBroker = databaseBroker
            addUserViewController.updateDelegate2 = DetailDelegate(tableView)
        }
    }  //새로운 유저 생성, pickerview에 넣을 그룹데이터 넘겨야함, userDatabase를 넘기고 새로운 userData를 추가해야함
    
    func f2(){ //데이터 베이스 생성하기, 그룹, 유저 데이터베이스 셋팅
        print("f2")
        databaseBroker = DatabaseObject.createDatabase(rootPath: rootPath)
        print("여기 잘됨")
        databaseBroker?.setUserDataDelegate(dataDelegate: self)
        databaseBroker?.setGroupDataDelegate(dataDelegate: self)
        userDatabase = databaseBroker!.loadUserDatabase()
        groupDatabase = databaseBroker!.loadGroupDatabase()
        print(userDatabase)
        print("f2 끝")
        print(groupDatabase)
        //databaseBroker?.setGroupDataDelegate(dataDelegate: self)
       // databaseBroker?.setUserDataDelegate(dataDelegate: self)
    }
    
    func onChange(userDatabaseStr: String) { //userData가 바뀔 때마다 호출
        print("user 바뀜")
        userDatabase = databaseBroker!.loadUserDatabase()
    }
    
    func onChange(groupDatabaseStr: String) {
        groupDatabase = databaseBroker!.loadGroupDatabase()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDatabase.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  //테이블 뷰에 추가
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell")! as! UserCell
        cell.updateLabels(userCell: cell)
        let user = userDatabase[indexPath.row]
        cell.userGroupLabel.text = user.group
        cell.idLabel.text = user.name
        cell.pwdLabel.text = user.password
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            userDatabase.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

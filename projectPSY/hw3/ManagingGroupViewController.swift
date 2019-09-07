//
//  ManagingGroupViewController.swift
//  hw3ManagerPSY
//
//  Created by psy on 20/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

class DetailDelegate: NSObject, UpdateDelegate{
    var tableView: UITableView
    init(_ tableView: UITableView){
        self.tableView = tableView
    }
    func updateChanged() {
        tableView.reloadData()
    }
}

class ManagingGroupViewController: UITableViewController,DatabaseDelegate {
    
    var databaseBroker: DatabaseBroker?
    var rootdatabaseBroker: DatabaseBroker?
    var groupDatabase = [String]()
    var userDatabase:[User] = []
    var rootPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("groupdatabase는")
        print(groupDatabase)
        f1()
        addGroup(indexpath1: 0)
        //navigationItem.backBarButtonItem = editButtonItem
        tableView.setEditing(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("그룹 다시 출력")
        print(groupDatabase)
        groupDatabase = databaseBroker!.loadGroupDatabase()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("출력")
          groupDatabase = databaseBroker!.loadGroupDatabase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseBroker?.saveGroupDatabase(groupDatabase: groupDatabase)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "CreateGroup"){
            let addGroupViewController = segue.destination as! AddGroupViewController
            addGroupViewController.groupDatabase = groupDatabase
            addGroupViewController.databaseBroker = databaseBroker
            addGroupViewController.updateDelegate = DetailDelegate(tableView)
        }
    }
    
    func addGroup(indexpath1: Int){
        let newGroup = groupDatabase[indexpath1]
        if let index = groupDatabase.index(of: newGroup){
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func f1(){
        print("f1")
        rootdatabaseBroker = DatabaseObject.createDatabase(rootPath: "test")
        //rootdatabaseBroker?.setUserDataDelegate(dataDelegate: self)
       // databaseBroker?.setUserDataDelegate(dataDelegate: self)
        databaseBroker?.setGroupDataDelegate(dataDelegate: self)
        groupDatabase = databaseBroker!.loadGroupDatabase()
        userDatabase = databaseBroker!.loadUserDatabase()
        print("userdatabase = ",userDatabase[1].name)
        print("groupdatabase = ",groupDatabase)
        rootdatabaseBroker?.saveUserDatabase(userDatabase: userDatabase)
        rootdatabaseBroker?.saveGroupDatabase(groupDatabase: groupDatabase)
        // databaseBroker?.setSettingDataDelegate(dataDelegate: self)
        //  databaseBroker?.setBookingDataDelegate(userGroup: userGroup, dataDelegate: self)
        
    }
    
    @IBAction func dissmissView(_ sender: Any) {  //메인화면으로
        print("뒤로가기")
        navigationController?.dismiss(animated: false, completion: nil)
        
    }
    
    func onChange(groupDatabaseStr: String) {

        groupDatabase = databaseBroker!.loadGroupDatabase()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupDatabase.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")! as! GroupCell
        cell.updateLabels(groupCell: cell)
        
        let group = groupDatabase[indexPath.row]
        cell.groupLabel.text = group
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            groupDatabase.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
}

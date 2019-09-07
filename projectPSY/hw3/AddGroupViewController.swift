//
//  AddGroupViewController.swift
//  hw3ManagerPSY
//
//  Created by psy on 26/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

protocol UpdateDelegate: NSObjectProtocol {
    func updateChanged()
}

class AddGroupViewController : UIViewController, UITextFieldDelegate, DatabaseDelegate {
    //그룹을 추가하는 컨트롤러
    var rootPath: String!
    var updateDelegate: UpdateDelegate!
    var databaseBroker: DatabaseBroker!{
        didSet{
            
        }
    }

    var groupDatabase: [String]! {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = updateDelegate {
            delegate.updateChanged()
        }
    }
    
    
    @IBOutlet weak var groupTextField: UITextField!
 
    @IBAction func addGroup(_ sender: UIButton) {
        for i in 0..<groupDatabase.count{
            if groupTextField.text == groupDatabase[i]{
                Message.information(parent: self, title: "오류", message: "이미 있는 그룹입니다.")
                break
            }
            if i == groupDatabase.count-1{
                groupDatabase.append(groupTextField.text!)
            }
        }
        print("이것존")
        print(groupDatabase)
        databaseBroker?.saveGroupDatabase(groupDatabase: groupDatabase)
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func cancelGroup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

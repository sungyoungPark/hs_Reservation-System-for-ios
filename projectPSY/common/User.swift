//
//  User.swift
//  HW1
//
//  Created by Jae Moon Lee on 23/01/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import Foundation

class User {
    var name: String
    var password: String
    var group: String
    
    init(toString: String){
        name = ""
        password = ""
        group = ""
        let components = toString.components(separatedBy: "####")
        if(components.count > 0){
            name = components[0]
        }
        if(components.count > 1){
            password = components[1]
        }
        if(components.count > 2){
            group = components[2]
        }
    }
    
    init(name: String, password: String, group: String){
        self.name = name
        self.password = password
        self.group = group
    }
    
    func toString() -> String {
        return name + "####" + password + "####" + group
    }
    
    
    func isMe(name: String, password: String, group: String) -> Bool {
        if self.password != password {
            return false
        }

        return isMe(name: name, group: group)
    }
    
    func isMe(name: String, group: String) -> Bool {
        if self.name == name {
            if name == "root"{
                return true
            }
            return isMe(group: group)
        }
        return false
    }
    
    func isRoot() -> Bool {
        return name == "root"
    }
    
    func isMe(name: String) -> Bool {
        return self.name == name
    }
    
    func isMe(password: String) -> Bool {
        return self.password == password
    }
    
    func isMe(group: String) -> Bool {
        return self.group == group
    }
}

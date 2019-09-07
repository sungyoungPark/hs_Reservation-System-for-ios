//
//  Preferences.swift
//  Booking App for Sharing Facility
//
//  Created by Jae Moon Lee on 08/02/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import Foundation

class Preferences: NSObject, NSCoding {
    var userType: Int
    var userGroup: Int
    var userName: String
    var userPassword: String
    var rootPath: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(userGroup, forKey: "userGroup")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(userPassword, forKey: "userPassword")
        aCoder.encode(rootPath, forKey: "rootPath")
    }
    
    override init(){
        userType = 0
        userGroup = 0
        userName = ""
        userPassword = ""
        rootPath = "PSY"
    }
    
    required init?(coder aDecoder: NSCoder) {
        userType = aDecoder.decodeInteger(forKey: "userType")
        userGroup = aDecoder.decodeInteger(forKey: "userGroup")
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        userPassword = aDecoder.decodeObject(forKey: "userPassword") as! String
        
        rootPath = "test"
        if let rootPathStr = aDecoder.decodeObject(forKey: "rootPath") as! String? {
            rootPath = rootPathStr
        }
        rootPath = "PSY"
    }
    
    static func loadPreferences() -> Preferences {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("preferences.archive")
        let preferences = NSKeyedUnarchiver.unarchiveObject(withFile: path.path) as! Preferences?
        if preferences == nil {
            return Preferences()
        }
        return preferences!
    }
    
    static func savePreferences(preferences: Preferences) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("preferences.archive")
       NSKeyedArchiver.archiveRootObject(preferences, toFile: path.path)
    }
    
    static func cleanPreferences(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("preferences.archive").path
        do {
            try FileManager.default.removeItem(atPath: path)
        }catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

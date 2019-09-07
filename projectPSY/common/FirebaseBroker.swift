//
//  FirebaseBroker.swift
//  projectPSY
//
//  Created by 박성영 on 17/06/2019.
//  Copyright © 2019 psy. All rights reserved.
//
import Foundation
import Firebase
import FirebaseDatabase

class FirebaseBroker: DatabaseObject, DatabaseBroker{
    
    static var  defaultGroups: String = "한성대테니스장@@@@제1스터디룸@@@@제2스터디룸@@@@세미나실"
    static var  defaultUsers: String = "root####root####@@@@gdhong####gdhong####한성대테니스장"
    static var  defaultSettings: String = "maxContinueBookingSlots:2####maxTotalBookingSlots:4"
    
    var ref: DatabaseReference!
    var refUSER: DatabaseReference!
    var refGROUP: DatabaseReference!
    var refBOOKING: DatabaseReference!
    var refSETTING: DatabaseReference!
    var rootPath = ""
    
    override init(){
        print("FirebaseBroker was created");
        refGROUP = Database.database().reference().child("Group")
        refUSER = Database.database().reference().child("User")
        refBOOKING = Database.database().reference().child("Booking")
        refSETTING = Database.database().reference().child("Setting")
        
    }
    
    //for group
    var  groupDatabaseStr = ""
    var  groupDataDelegate: DatabaseDelegate?
    
    func myObserver(dataSnapshot: DataSnapshot) {
        groupDatabaseStr = dataSnapshot.value as! String
        groupDataDelegate?.onChange?(groupDatabaseStr: groupDatabaseStr)
    }
    
    func setGroupDataDelegate(dataDelegate: DatabaseDelegate?) {
        groupDataDelegate = dataDelegate
        refGROUP.observe(.value, with: myObserver(dataSnapshot:))
        //if groupDatabaseStr.count == 0 {
            //groupDatabaseStr = FirebaseBroker.defaultGroups
            //refGROUP.setValue(FirebaseBroker.defaultGroups)
       // }
        if let delegate = groupDataDelegate{
            delegate.onChange!(groupDatabaseStr: groupDatabaseStr)
        }
    }
    
    func loadGroupDatabase() -> [String] {
        var groupDatabase = [String]()
        let groupStrs = groupDatabaseStr.components(separatedBy: "@@@@")

        for groupStr in groupStrs {
            if groupStr.count == 0 {
                continue
            }
            groupDatabase.append(groupStr)
        }
        return groupDatabase
    }
    
    func saveGroupDatabase(groupDatabase: [String]?) {
        groupDatabaseStr = ""
        if let groups = groupDatabase {
            for group in groups {
                groupDatabaseStr += group + "@@@@"
            }
        }
        refGROUP.setValue(groupDatabaseStr)
        if let delegate = groupDataDelegate{
            delegate.onChange!(groupDatabaseStr: groupDatabaseStr)
        }
    }
    
    
    
    //for user
    var  userDataDelegate: DatabaseDelegate?
    var  userDatabaseStr: String = ""
    
    func myObserver1(dataSnapshot: DataSnapshot) {
        userDatabaseStr = dataSnapshot.value as! String
        userDataDelegate?.onChange?(groupDatabaseStr:userDatabaseStr)
    }
    
    func setUserDataDelegate(dataDelegate: DatabaseDelegate?) {
        userDataDelegate = dataDelegate
        refUSER.observe(.value, with: myObserver1(dataSnapshot:))
        if userDatabaseStr.count == 0 {
           userDatabaseStr = FirebaseBroker.defaultUsers
           refUSER.setValue(userDatabaseStr)
        }
        
        if let delegate = userDataDelegate{
            delegate.onChange!(userDatabaseStr: userDatabaseStr)
        }
    }
    
    func loadUserDatabase() -> [User] {
        var userDatabase = [User]()
        let userStrs = userDatabaseStr.components(separatedBy: "@@@@")
        for userStr in userStrs {
            if userStr.count == 0 {
                continue
            }
            let user = User(toString: userStr)
            userDatabase.append(user)
        }
        return userDatabase
    }
    
    func saveUserDatabase(userDatabase: [User]?) {
        userDatabaseStr = ""
        if let users = userDatabase {
            for user in users {
                userDatabaseStr += user.toString() + "@@@@"
            }
        }
        refUSER.setValue(userDatabaseStr)
        if let delegate = userDataDelegate{
            delegate.onChange!(userDatabaseStr: userDatabaseStr)
        }
    }
    
    //for bookingData
    var userGroup = ""
    var bookingDatabaseStr = ""
    var bookingDataDelegate: DatabaseDelegate?
    func myObserver2(dataSnapshot: DataSnapshot) {
        bookingDatabaseStr = dataSnapshot.value as! String
        bookingDataDelegate?.onChange?(bookingDatabaseStr: bookingDatabaseStr)
    }
    
    func setBookingDataDelegate(userGroup: String, dataDelegate: DatabaseDelegate?) {
        self.userGroup = userGroup
        bookingDataDelegate = dataDelegate
        refBOOKING = refBOOKING.child(userGroup)
        refBOOKING.observe(.value, with: myObserver2(dataSnapshot:))
//        if bookingDatabaseStr.count == 0 {
//                           bookingDatabaseStr = ""
//                            refBOOKING.setValue(bookingDatabaseStr)
//                        }
        if let delegate = bookingDataDelegate{
            delegate.onChange!(bookingDatabaseStr: bookingDatabaseStr)
        }
    }
    
    func loadBookingDatabase(userGroup: String) -> [String] {
        if userGroup != self.userGroup {
//                        if bookingDatabaseStr.count == 0 {
//                            bookingDatabaseStr = ""
//                           refBOOKING.setValue(bookingDatabaseStr)
//                       }
            self.userGroup = userGroup
        }
        
        var bookingDatabase: [String] = []
        for _ in 0..<50 {
            bookingDatabase.append("")
        }
        if bookingDatabaseStr.count == 0 {
            return bookingDatabase
        }
        
        var bookings = bookingDatabaseStr.components(separatedBy: "@@@@")
        
        for i in 1..<bookings.count {
            if bookings[i].count == 0 {
                continue
            }
            
            let info = bookings[i].components(separatedBy: ":")
            let time = Int(info[0])!
            let index = (time/100)*2 + ((time%100)/30)
            bookingDatabase[index] = info[1]
        }
        
        let date = Date()
        let calender = Calendar.current
        let c = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let dateStr = String.init(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
        
        if dateStr != bookings[0] {
            bookingDatabase[0] = bookingDatabase[48]
            bookingDatabase[1] = bookingDatabase[49]
            for i in 2..<50 {
                bookingDatabase[i] = ""
            }
            //saveBooking(booked: booked, userGroup: userGroup)
        }
        return bookingDatabase
    }
    
    func saveBookingDatabase(userGroup: String, bookingDatabase: [String]) {
        
        let date = Date()
        let calender = Calendar.current
        let c = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let dateStr = String.init(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
        
        var str = dateStr + "@@@@"
        for i in 0..<bookingDatabase.count {
            if bookingDatabase[i].count == 0 {
                continue
            }
            let time = (i/2)*100 + (i%2)*30
            let element = String(time) + ":" + bookingDatabase[i] + "@@@@"
            str = str + element
        }
        print("save")
        self.userGroup = userGroup
        bookingDatabaseStr = str
        refBOOKING.setValue(bookingDatabaseStr)
        if let delegate = bookingDataDelegate{
            delegate.onChange!(bookingDatabaseStr: bookingDatabaseStr)
        }
    }
    
    // for setting -------------------------------------------
    var  settingDatabaseStr: String = ""
    var  settingDataDelegate: DatabaseDelegate?
    
    func myObserver3(dataSnapshot: DataSnapshot) {
        settingDatabaseStr = dataSnapshot.value as! String
    }
    
    func setSettingDataDelegate(dataDelegate: DatabaseDelegate?) {
        settingDataDelegate = dataDelegate
        refSETTING.observe(.value, with: myObserver3(dataSnapshot:))
        if settingDatabaseStr.count == 0 {
            refSETTING.setValue(FirebaseBroker.defaultSettings)
        }
        if let delegate = settingDataDelegate{
            delegate.onChange!(settingDatabaseStr: settingDatabaseStr)
        }
    }
    
    func loadSettingDatabase() -> Setting {
        let settingDatabase = Setting(str: settingDatabaseStr)
        return settingDatabase
    }
    
    func saveSettingDatabase(settingDatabase: Setting) {
        settingDatabaseStr = settingDatabase.toString()
        refSETTING.setValue(settingDatabaseStr)
        if let delegate = settingDataDelegate{
            delegate.onChange!(settingDatabaseStr: settingDatabaseStr)
        }
    }
    
    // for database --------------------------------------------
    var  databaseRootDelegate: DatabaseDelegate?
    
    func setCheckDatabaseRoot(dataDelegate: DatabaseDelegate?) {
        self.databaseRootDelegate = dataDelegate
        if let delegate = databaseRootDelegate{
            delegate.onChange!(databaseRootStr: DatabaseObject.rootPath)
        }
    }
    
    func resetDatabase() {
        print("good")
        // var refALL: DatabaseReference?
        //refALL = Database.database().reference()
        //refALL?.removeAllObservers()
    }
}


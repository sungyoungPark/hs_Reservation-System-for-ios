//
//  FilebaseBroker.swift
//  Booking App for Sharing Facility
//
//  Created by Jae Moon Lee on 17/02/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import Foundation


class FilebaseBroker: DatabaseObject, DatabaseBroker {
    static var  defaultGroups: String = "한성대테니스장@@@@제1스터디룸@@@@제2스터디룸@@@@세미나실"
    static var  defaultUsers: String = "root####root####@@@@gdhong####gdhong####한성대테니스장"
    static var  defaultSettings: String = "maxContinueBookingSlots:2####maxTotalBookingSlots:4"
    
    override init(){
        print("FilebaseBroker was created");
    }
    
    
    // for groups -------------------------------------------
    var  groupDatabaseStr: String = ""
    var  groupDataDelegate: DatabaseDelegate?
    
    func groupsArchiveURL() -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(DatabaseObject.rootPath+"-groups.archive")
    }
    
    public func setGroupDataDelegate(dataDelegate: DatabaseDelegate?){
        
        groupDataDelegate = dataDelegate
        
        let archivableString = NSKeyedUnarchiver.unarchiveObject(withFile: groupsArchiveURL().path) as! ArchivableString?
        if let archive = archivableString {
            groupDatabaseStr = archive.value
        }
        if groupDatabaseStr.count == 0 {
            groupDatabaseStr = FilebaseBroker.defaultGroups
        }
        
        if let delegate = groupDataDelegate{
            delegate.onChange!(groupDatabaseStr: groupDatabaseStr)
        }
        
    }
    
    public  func loadGroupDatabase() -> [String] {
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
    
    public  func saveGroupDatabase(groupDatabase: [String]?){
        groupDatabaseStr = ""
        if let groups = groupDatabase {
            for group in groups {
                groupDatabaseStr += group + "@@@@"
            }
        }
        
        let archivableString = ArchivableString(value:groupDatabaseStr)
        NSKeyedArchiver.archiveRootObject(archivableString, toFile: groupsArchiveURL().path)
        
        if let delegate = groupDataDelegate{
            delegate.onChange!(groupDatabaseStr: groupDatabaseStr)
        }
    }
    
    // for users -------------------------------------------
    var  userDatabaseStr: String = ""
    var  userDataDelegate: DatabaseDelegate?
    
    
    func  usersArchiveURL() -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(DatabaseObject.rootPath+"-users.archive")
    }
    
    public func setUserDataDelegate(dataDelegate: DatabaseDelegate?){
        
        userDataDelegate = dataDelegate
        
        let archivableString = NSKeyedUnarchiver.unarchiveObject(withFile: usersArchiveURL().path) as! ArchivableString?
        if let archive = archivableString {
            userDatabaseStr = archive.value
        }
        if userDatabaseStr.count == 0 {
            userDatabaseStr = FilebaseBroker.defaultUsers
        }
        
        if let delegate = userDataDelegate{
            delegate.onChange!(userDatabaseStr: userDatabaseStr)
        }
        
    }
    
    public  func loadUserDatabase() -> [User] {
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
    
    public  func saveUserDatabase(userDatabase: [User]?){
        userDatabaseStr = ""
        if let users = userDatabase {
            for user in users {
                userDatabaseStr += user.toString() + "@@@@"
            }
        }
        
        let archivableString = ArchivableString(value:userDatabaseStr)
        NSKeyedArchiver.archiveRootObject(archivableString, toFile: usersArchiveURL().path)
        
        if let delegate = userDataDelegate{
            delegate.onChange!(userDatabaseStr: userDatabaseStr)
        }
    }
    
    // for booking -------------------------------------------
    var userGroup = ""
    var bookingDatabaseStr = ""
    var bookingDataDelegate: DatabaseDelegate?
    
   
    public func bookingArchiveURL(userGroup: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(DatabaseObject.rootPath+"-bookings-"+userGroup+".archive")
    }
    
    public func setBookingDataDelegate(userGroup: String, dataDelegate: DatabaseDelegate?){
        
        self.userGroup = userGroup
        bookingDataDelegate = dataDelegate
        
        let archivableString = NSKeyedUnarchiver.unarchiveObject(withFile: bookingArchiveURL(userGroup: userGroup).path) as! ArchivableString?
        
        if let archive = archivableString {
            bookingDatabaseStr = archive.value
        }else{
            bookingDatabaseStr = ""
        }
        
        if let delegate = bookingDataDelegate{
            delegate.onChange!(bookingDatabaseStr: bookingDatabaseStr)
        }
        
        
        
    }
    
    public  func loadBookingDatabase(userGroup: String) -> [String] {
        
        if userGroup != self.userGroup {
            let archivableString = NSKeyedUnarchiver.unarchiveObject(withFile: bookingArchiveURL(userGroup: userGroup).path) as! ArchivableString?
            
            if let archive = archivableString {
                bookingDatabaseStr = archive.value
            }else{
                bookingDatabaseStr = ""
            }
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
    
    public  func saveBookingDatabase(userGroup: String, bookingDatabase: [String]){
        
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
        
        self.userGroup = userGroup
        bookingDatabaseStr = str
        let archivableString = ArchivableString(value:bookingDatabaseStr)
        NSKeyedArchiver.archiveRootObject(archivableString, toFile: bookingArchiveURL(userGroup: userGroup).path)
        
        if let delegate = bookingDataDelegate{
            delegate.onChange!(bookingDatabaseStr: bookingDatabaseStr)
        }
        
        /*
         let databaseRefenerce = Database.database().reference().child("booking").child(userGroup)
         databaseRefenerce.setValue(bookingStr)
         */
    }
    
    // for setting -------------------------------------------
    var  settingDatabaseStr: String = ""
    var  settingDataDelegate: DatabaseDelegate?
    
    /*
    var  settingsArchiveURL: URL = {
        var docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent("setting.archive")
    }()
    */
    func  settingsArchiveURL() -> URL{
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(DatabaseObject.rootPath+"-setting.archive")
    }
    
    public func setSettingDataDelegate(dataDelegate: DatabaseDelegate?){
        
        settingDataDelegate = dataDelegate
        
        let archivableString = NSKeyedUnarchiver.unarchiveObject(withFile: settingsArchiveURL().path) as! ArchivableString?
        if let archive = archivableString {
            settingDatabaseStr = archive.value
        }
        if settingDatabaseStr.count == 0 {
            settingDatabaseStr = FilebaseBroker.defaultSettings
        }
        
        if let delegate = settingDataDelegate{
            delegate.onChange!(settingDatabaseStr: settingDatabaseStr)
        }
        
    }
    
    public  func loadSettingDatabase() -> Setting {
        let settingDatabase = Setting(str: settingDatabaseStr)
        return settingDatabase
    }
    
    public  func saveSettingDatabase(settingDatabase: Setting){
        settingDatabaseStr = settingDatabase.toString()
        
        let archivableString = ArchivableString(value:settingDatabaseStr)
        NSKeyedArchiver.archiveRootObject(archivableString, toFile: settingsArchiveURL().path)
        
        if let delegate = settingDataDelegate{
            delegate.onChange!(settingDatabaseStr: settingDatabaseStr)
        }
    }
    
    // for database --------------------------------------------
    var  databaseRootDelegate: DatabaseDelegate?
    //var  databaseRootStr: String = ""

    func setCheckDatabaseRoot(dataDelegate: DatabaseDelegate?) {
        self.databaseRootDelegate = dataDelegate
        
        if let delegate = databaseRootDelegate{
            delegate.onChange!(databaseRootStr: DatabaseObject.rootPath)
        }
    }
    
    func resetDatabase() {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = docDir.appendingPathComponent(DatabaseObject.rootPath+"-*.*").path
        do {
            try FileManager.default.removeItem(atPath: path)
        }catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

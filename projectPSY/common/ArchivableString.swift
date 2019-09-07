//
//  ArchivableString.swift
//  HW1
//
//  Created by Jae Moon Lee on 29/01/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import Foundation

class ArchivableString:NSObject, NSCoding {
    var value:String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as! String
    }
    
    init(value:String){
        self.value = value
    }
}

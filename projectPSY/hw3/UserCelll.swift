//
//  UserCelll.swift
//  hw3ManagerPSY
//
//  Created by psy on 28/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

class UserCell : UITableViewCell{
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var pwdLabel: UILabel!
    @IBOutlet var userGroupLabel: UILabel!
    
    func updateLabels(userCell: UserCell ){
        let bodyFont = UIFont.preferredFont(forTextStyle:.body)
        userCell.idLabel.font = bodyFont
        userCell.pwdLabel.font = bodyFont
        userCell.userGroupLabel.font = bodyFont
    }
    
}

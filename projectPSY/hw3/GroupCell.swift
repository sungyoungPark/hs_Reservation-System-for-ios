//
//  GroupCell.swift
//  hw3ManagerPSY
//
//  Created by psy on 27/05/2019.
//  Copyright © 2019 psy. All rights reserved.
//

import UIKit

class GroupCell : UITableViewCell{  //그룹을 저장하기 위한 클래스
    
    @IBOutlet var groupLabel: UILabel!    
    func updateLabels(groupCell: GroupCell ){
        let bodyFont = UIFont.preferredFont(forTextStyle:.body)
        groupCell.groupLabel.font = bodyFont
    }
    
}

//
//  Message.swift
//  HW1
//
//  Created by Jae Moon Lee on 23/01/2019.
//  Copyright © 2019 Jae Moon Lee. All rights reserved.
//

import UIKit

class Message {
    static public func information(parent: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        parent.present(alertController, animated: true, completion: nil)
    }
}


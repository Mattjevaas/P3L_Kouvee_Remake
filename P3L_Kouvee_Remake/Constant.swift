//
//  Constant.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    static let url: String = "https://api.digiprint.pw/public"
    static let urlStorage: String = "https://api.digiprint.pw/storage/app"
    static var APIKEY = ""
    
    static func showAlert(title: String, message: String, sender: UIViewController, back: Bool)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if back
        {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in sender.navigationController?.popToRootViewController(animated: true)}))
        }
        else
        {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        
    
        sender.present(alert, animated: true, completion: nil)
    }
    
    static func randomString(length: Int) -> String
    {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

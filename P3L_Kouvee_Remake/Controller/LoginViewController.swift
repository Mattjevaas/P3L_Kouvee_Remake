//
//  ViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var loginManager = LoginManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginManager.delegate = self
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2
        EmailTxt.text = "admin@admin.com"
        PasswordTxt.text = "hapie123"
        
        
    }

    @IBAction func LoginBtn(_ sender: UIButton)
    {
        
        let email = EmailTxt.text
        let password = PasswordTxt.text
        
        if email != nil, password != nil
        {
            loginManager.check_login(email: email!, password: password!)
        }
        
    }
    
}


//MARK: - LoginManagerDelegate

extension LoginViewController: LoginManagerDelegate
{
    func didSuccess(data: Login) {
        performSegue(withIdentifier: "toCustomer", sender: self)
    }
    
    func didError(message: String) {
        Constant.showAlert(title: "Error", message: message, sender: self, back: false)
    }
    
    
}

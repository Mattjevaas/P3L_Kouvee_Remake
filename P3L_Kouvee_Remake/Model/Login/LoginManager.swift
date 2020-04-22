//
//  LoginManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

import Alamofire

protocol LoginManagerDelegate {
    
    func didSuccess(data: Login)
    func didError(message: String)
    
}

struct LoginManager {
    
    var delegate: LoginManagerDelegate?
    let url = "\(Constant.url)/login_user"
    
    func check_login(email: String, password: String)
    {
        let login = LoginData(email: email, password: password)
        
        AF.request(url, method: .post, parameters: login).response { response in
            
            if let responseData = response.data
            {
                if let safeData = self.parseJson(data: responseData)
                {
                    if(safeData.Status == "Success")
                    {
                        Constant.APIKEY = safeData.Token
                        self.delegate?.didSuccess(data: safeData)
                    }
                    else
                    {
                        self.delegate?.didError(message: "Username / Password Salah !")
                    }
                }
            }
            else
            {
                self.delegate?.didError(message: "Something Wrong !")
            }
            
        }
    }
    
    func parseJson(data: Data) -> Login?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(Login.self, from: data)
            let status = decodedData.Status
            let token = decodedData.Token
            
            let LoginData = Login(Status: status, Token: token)
            
            return LoginData
        }
        catch
        {
            self.delegate?.didError(message: "Something Wrong !")
            return nil
        }
    }
    
}

//
//  Login.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Login: Codable
{
    let Status: String
    let Token: String
}

struct LoginData: Codable
{
    let email: String
    let password: String
}

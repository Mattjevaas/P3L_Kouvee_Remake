//
//  Customer.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Customer: Codable
{
    let Status: String
    let Data: [CustomerData]
}

struct CustomerData: Codable
{
    let idCustomer_Member: Int
    let namaCustomer: String
    let tglLahir: String
    let alamat: String
    let noTelp: String
    let email: String
}

struct CustomerDataStore: Codable
{
    let namaCustomer: String
    let tglLahir: String
    let alamat: String
    let noTelp: String
    let email: String
}

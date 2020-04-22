//
//  Supplier.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Supplier: Codable
{
    let Status: String
    let Data: [SupplierData]
}

struct SupplierData: Codable
{
    let idSupplier: Int
    let namaSupplier: String
    let alamat: String
    let noTelp: String
    let email: String
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct SupplierDataStore: Codable
{
    let namaSupplier: String
    let alamat: String
    let noTelp: String
    let email: String
}

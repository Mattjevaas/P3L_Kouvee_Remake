//
//  ProdukLayanan.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ProdukLayanan: Codable
{
    let Status: String
    let Data: [ProdukLayananData]
}

struct ProdukLayananData: Codable
{
    let idLayanan: Int
    let namaLayanan: String
    let created_at: String?
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct ProdukLayananDataStore: Codable
{
    let namaLayanan: String
}

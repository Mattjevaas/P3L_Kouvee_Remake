//
//  Ukuran.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct UkuranHewan: Codable
{
    let Status: String
    let Data: [UkuranHewanData]
}

struct UkuranHewanData: Codable
{
    let idUkuranHewan: Int
    let ukuranHewan: String
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct UkuranHewanDataStore: Codable
{
    let ukuranHewan: String
}

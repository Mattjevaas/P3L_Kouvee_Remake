//
//  JenisHewan.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct JenisHewan: Codable
{
    let Status: String
    let Data: [JenisHewanData]
}

struct JenisHewanData: Codable
{
    let idJenisHewan: Int
    let jenisHewan: String
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct JenisHewanDataStore: Codable
{
    let jenisHewan: String
}

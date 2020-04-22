//
//  Hewan.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Hewan: Codable
{
    let Status: String
    let Data: [HewanData]
}

struct HewanData: Codable
{
    let idHewan: Int
    let namaHewan: String
    let tglLahir: String
    let idUkuranHewan: UkuranHewanData
    let idJenisHewan: JenisHewanData
    let idCustomer_Member: CustomerData
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct HewanDataStore: Codable
{
    let namaHewan: String
    let tglLahir: String
    let idUkuranHewan: Int
    let idJenisHewan: Int
    let idCustomer_Member: Int
}

//
//  HargaLayanan.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct HargaLayanan: Codable
{
    let Status: String
    let Data: [HargaLayananData]
}

struct HargaLayananData: Codable
{
    let idHargaLayanan: Int
    let hargaLayanan: String
    let idUkuranHewan: UkuranHewanData
    let idJenisHewan: JenisHewanData
    let idLayanan: ProdukLayananData
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct HargaLayananDataStore: Codable
{
    let hargaLayanan: String
    let idUkuranHewan: Int
    let idJenisHewan: Int
    let idLayanan: Int
}

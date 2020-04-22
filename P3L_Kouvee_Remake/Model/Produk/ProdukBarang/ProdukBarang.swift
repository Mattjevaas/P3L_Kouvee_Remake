//
//  ProdukBarang.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 22/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ProdukBarang: Codable
{
    let Status: String
    let Data: [ProdukBarangData]
}

struct ProdukBarangData: Codable
{
    let idProduk: Int
    let namaProduk: String
    let satuan: String
    let jumlahProduk: String
    let hargaJual: String
    let hargaBeli: String
    let stokMinimal: String
    let linkGambar: String
    let created_at: String
    let edited_at: String?
    let deleted_at: String?
    let edited_by: String
}

struct ProdukBarangDataStore: Codable
{
    let namaProduk: String
    let satuan: String
    let jumlahProduk: String
    let hargaJual: String
    let hargaBeli: String
    let stokMinimal: String
}

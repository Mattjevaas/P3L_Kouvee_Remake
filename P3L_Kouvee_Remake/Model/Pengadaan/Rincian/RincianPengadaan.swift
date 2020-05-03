//
//  RincianPengadaan.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 28/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct RincianPengadaan: Codable
{
    let Status: String
    let Data: [RincianPengadaanData]
}

struct RincianPengadaanData: Codable
{
    let idRincianPengadaan: Int
    let jumlahBeli: String
    let idPengadaanBarang: PengadaanBarangDataSpecial
    let idProduk: ProdukBarangData
}

struct RincianPengadaanDataStore: Codable
{
    let jumlahBeli: Int
    let idPengadaanBarang: Int
    let idProduk: Int
}

struct RincianPengadaanDataSpecial: Codable
{
    let idRincianPengadaan: Int
    let jumlahBeli: String
    let idPengadaanBarang: String
    let idProduk: ProdukBarangData
}

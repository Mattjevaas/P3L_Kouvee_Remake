//
//  PengadaanBarang.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 28/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct PengadaanBarang: Codable
{
    let Status: String
    let Data: [PengadaanBarangData]
}

struct PengadaanBarangData: Codable
{
    let idPengadaanBarang: Int
    let namaPengadaan: String
    let tglPengadaan: String
    let statusBrgDatang: String
    let statusCetak: String
    let idSupplier: SupplierData
    let listProduct: [RincianPengadaanDataSpecial]
}

struct PengadaanBarangDataStore: Codable
{
    let namaPengadaan: String
    let idSupplier: Int
}

struct PengadaanBarangDataSpecial: Codable
{
    let idPengadaanBarang: Int
    let namaPengadaan: String
    let tglPengadaan: String
    let statusBrgDatang: String
    let statusCetak: String
    let idSupplier: String
}

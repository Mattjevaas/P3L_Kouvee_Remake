//
//  Transaksi.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Transaksi: Codable
{
    let Status: String
    let Data: [TransaksiData?]
}

struct TransaksiData: Codable
{
    let idTransaksiPembayaran: Int
    let totalBayar: String
    let tglTransaksi: String
    let jenisTransaksi: String
    let statusSelesai: String?
    let statusLunas: String
    let idPegawai: String
    let idHewan: HewanData?
    var listProduct: [RincianPembelianData]
}

struct TransaksiDataStore: Codable
{
    let jenisTransaksi: String
    let idHewan: Int?
}

struct TransaksiSMS: Codable
{
    let api_key: String
    let api_secret: String
    let to: String
    let from: String
    let text: String
    
}

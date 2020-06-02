//
//  RincianPembelian.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct RincianPembelian: Codable
{
    let Status: String
    let Data: [TransaksiData?]
}

struct RincianPembelianData: Codable
{
    let idRincianPembelian: Int
    let jumlahBeli: String
    let jenisPembelian: String
    let idProduk: ProdukBarangData?
    let idHargaLayanan: HargaLayananData?
    let idTransaksiPembayaran: String
}

struct RincianPembelianDataStore: Codable
{
    let jumlahBeli: Int
    let jenisPembelian: String
    let idProduk: Int?
    let idHargaLayanan: Int?
    let idTransaksiPembayaran: Int
}

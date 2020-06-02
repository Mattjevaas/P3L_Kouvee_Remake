//
//  RincianPembelianManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol RincianPembelianManagerDelegate
{
    func didFetchRincianPembelian(transaksi: RincianPembelian)
    func didMessageRincianPembelian(title:String, message: String)
}

struct RincianPembelianManager
{
    
    var delegate: RincianPembelianManagerDelegate?
    let url = "\(Constant.url)/rincianpembelian"
    
    func store_data(jumlahBeli: Int, jenisPembelian: String, idProduk: Int?, idHargaLayanan: Int?, idTransaksiPembayaran: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = RincianPembelianDataStore(jumlahBeli: jumlahBeli, jenisPembelian: jenisPembelian, idProduk: idProduk, idHargaLayanan: idHargaLayanan, idTransaksiPembayaran: idTransaksiPembayaran)
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageRincianPembelian(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessageRincianPembelian(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageRincianPembelian(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(jumlahBeli: Int, jenisPembelian: String, idProduk: Int?, idHargaLayanan: Int?, idTransaksiPembayaran: Int, id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = RincianPembelianDataStore(jumlahBeli: jumlahBeli, jenisPembelian: jenisPembelian, idProduk: idProduk, idHargaLayanan: idHargaLayanan, idTransaksiPembayaran: idTransaksiPembayaran)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageRincianPembelian(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessageRincianPembelian(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageRincianPembelian(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func delete_data(id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/\(id)"
        
        
        AF.request(urls, method: .delete ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageRincianPembelian(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageRincianPembelian(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessageRincianPembelian(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> RincianPembelian?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(RincianPembelian.self, from: data)
            let rincianData = decodedData
            
            return rincianData
        }
        catch{
            debugPrint(error)
            self.delegate?.didMessageRincianPembelian(title: "Error", message: error.localizedDescription)
            return nil
        }
    }
    
    
}


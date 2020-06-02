//
//  TransaksiManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol TransaksiManagerDelegate
{
    func didFetchTransaksi(transaksi: Transaksi)
    func didMessageTransaksi(title:String, message: String)
}

struct TransaksiManager
{
    
    var delegate: TransaksiManagerDelegate?
    let url = "\(Constant.url)/transaksipembayaran"
    
    
    
    func fetch_all()
    {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(Constant.APIKEY)", forHTTPHeaderField:"Authorization" )
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        AF.request(req).response { response in
            debugPrint(response)
            if let data = response.data
            {
                if let safeData = self.parseJson(data: data)
                {
                    self.delegate?.didFetchTransaksi(transaksi: safeData)

                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String, idHewan: Int?)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = TransaksiDataStore(jenisTransaksi: nama, idHewan: idHewan)
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageTransaksi(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(nama: String, idHewan: Int?,id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = TransaksiDataStore(jenisTransaksi: nama, idHewan: idHewan)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageTransaksi(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessageTransaksi(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func confirm_selesai(id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/selesai/\(id)"
        
        AF.request(urls, method: .post ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageTransaksi(title: "Success", message: "Success Update Data !")
                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Update Data !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func sendSms(number: String, namaPelanggan: String, layanan: String, namaHewan: String)
    {
        let urls = "https://rest.nexmo.com/sms/json"
        
        let text = "Kepada Yth, \(namaPelanggan) layanan dengan kode \(layanan) atas nama hewan \(namaHewan) sudah selesai"
        let param = TransaksiSMS(api_key: "f7961965", api_secret: "8Xuybwk5di0rtKkj", to: number, from: "Kouvee PetShop", text: text)
        
        AF.request(urls, method: .post, parameters: param).response { response in
            
            
            if let data = response.data
            {
                debugPrint(data)
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageTransaksi(title: "Success", message: "Success Send SMS !")
                }
                else
                {
                    self.delegate?.didMessageTransaksi(title: "Error", message: "Failed Send SMS !")
                }
            }
            else
            {
                self.delegate?.didMessageTransaksi(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> Transaksi?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(Transaksi.self, from: data)
            let pengadaanBarangData = decodedData
            
            return pengadaanBarangData
        }
        catch{
            debugPrint(error)
            self.delegate?.didMessageTransaksi(title: "Error", message: error.localizedDescription)
            return nil
        }
    }
    
    
}

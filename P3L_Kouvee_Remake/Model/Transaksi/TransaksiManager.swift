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

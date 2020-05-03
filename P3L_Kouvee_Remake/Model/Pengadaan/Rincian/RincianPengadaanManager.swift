//
//  RincianPengadaanManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 28/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol RincianPengadaanManagerDelegate
{
    func didFetchRincianPengadaan(rincianPengadaan: RincianPengadaan)
    func didMessageRincianPengadaan(title:String, message: String)
}

struct RincianPengadaanManager
{
    
    var delegate: RincianPengadaanManagerDelegate?
    let url = "\(Constant.url)/rincianpengadaan"
    
    
    
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
                    self.delegate?.didFetchRincianPengadaan(rincianPengadaan: safeData)
                    
                }
                else
                {
                    self.delegate?.didMessageRincianPengadaan(title: "Error", message: "Failed Fetching Data !")
                }
            }
        }
    }
    
    func store_data(jumlah: Int, idPengadaan: Int, idProduk: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = RincianPengadaanDataStore(jumlahBeli: jumlah, idPengadaanBarang: idPengadaan, idProduk: idProduk)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageRincianPengadaan(title: "Success", message: "Success Store Data !")
                }
                else
                {
                    self.delegate?.didMessageRincianPengadaan(title: "Error", message: "Failed Store Data !")
                }
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
                    self.delegate?.didMessageRincianPengadaan(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageRincianPengadaan(title: "Error", message: "Failed Delete Data !")
                }
            }
        }
    }
    
    func parseJson(data: Data) -> RincianPengadaan?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(RincianPengadaan.self, from: data)
            let rincianPengadaanData = decodedData
            
            return rincianPengadaanData
        }
        catch{
            self.delegate?.didMessageRincianPengadaan(title: "Error", message: "Error Parsing Data !")
            return nil
        }
    }
    
    
}

//
//  ProdukLayananManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol ProdukLayananManagerDelegate
{
    func didFetch(produkLayanan: ProdukLayanan)
    func didMessage(title:String, message: String)
}

struct ProdukLayananManager
{
    var delegate: ProdukLayananManagerDelegate?
    let url = "\(Constant.url)/layanan"
    
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
                    self.delegate?.didFetch(produkLayanan: safeData)
                    
                }
                else
                {
                    self.delegate?.didMessage(title: "Error",message: "Failed Fetching Data !")
                }
                
            }
            else
            {
                self.delegate?.didMessage(title: "Error",message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = ProdukLayananDataStore(namaLayanan: nama)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessage(title: "Success",message: "Success Store Data!")
                }
                else
                {
                    self.delegate?.didMessage(title: "Error",message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error",message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(nama: String,id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = ProdukLayananDataStore(namaLayanan: nama)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessage(title: "Success",message: "Success Edit Data!")
                }
                else
                {
                    self.delegate?.didMessage(title: "Error",message: "Failed Edit Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error",message: "Network Error !")
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
                    self.delegate?.didMessage(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessage(title: "Error",message: "Failed Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error",message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> ProdukLayanan?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(ProdukLayanan.self, from: data)
            let produkLayananData = decodedData
            
            return produkLayananData
        }
        catch{
            self.delegate?.didMessage(title: "Error",message: "Error Parsing Data !")
            return nil
        }
    }
}

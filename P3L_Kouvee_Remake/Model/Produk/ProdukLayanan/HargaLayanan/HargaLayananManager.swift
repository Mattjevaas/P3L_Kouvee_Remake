//
//  HargaLayananManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol HargaLayananManagerDelegate
{
    func didFetchHargaLayanan(hargalayanan: HargaLayanan)
    func didMessageHargaLayanan(title:String, message: String)
}

struct HargaLayananManager
{
    
    var delegate: HargaLayananManagerDelegate?
    let url = "\(Constant.url)/hargalayanan"
    
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
                    self.delegate?.didFetchHargaLayanan(hargalayanan: safeData)

                }
                else
                {
                    self.delegate?.didMessageHargaLayanan(title: "Error",message: "Failed Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessageHargaLayanan(title: "Error",message: "Network Error !")
            }
        }
    }
    
    func store_data(harga: String, idUkuran: Int, idJenis: Int, idLayanan: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = HargaLayananDataStore(hargaLayanan: harga, idUkuranHewan: idUkuran, idJenisHewan: idJenis, idLayanan: idLayanan)
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageHargaLayanan(title: "Success",message: "Success Store Data!")
                }
                else
                {
                    self.delegate?.didMessageHargaLayanan(title: "Error",message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageHargaLayanan(title: "Error",message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(harga: String, idUkuran: Int, idJenis: Int, idLayanan: Int, id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = HargaLayananDataStore(hargaLayanan: harga, idUkuranHewan: idUkuran, idJenisHewan: idJenis, idLayanan: idLayanan)
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageHargaLayanan(title: "Success",message: "Success Edit Data!")
                }
                else
                {
                    self.delegate?.didMessageHargaLayanan(title: "Error",message: "Failed Edit Data !")
                }
            }
            else
            {
                self.delegate?.didMessageHargaLayanan(title: "Error",message: "Network Error !")
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
                    self.delegate?.didMessageHargaLayanan(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageHargaLayanan(title: "Error",message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessageHargaLayanan(title: "Error",message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> HargaLayanan?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(HargaLayanan.self, from: data)
            let hargalayananData = decodedData
            
            return hargalayananData
        }
        catch{
            self.delegate?.didMessageHargaLayanan(title: "Error",message: "Failed Parsing Data !")
            return nil
        }
    }
}


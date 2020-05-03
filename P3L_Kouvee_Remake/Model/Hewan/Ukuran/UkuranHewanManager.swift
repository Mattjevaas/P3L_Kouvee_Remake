//
//  UkuranManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol UkuranHewanManagerDelegate
{
    func didFetchUkuran(ukuranhewan: UkuranHewan)
    func didMessageUkuran(title: String, message: String)
}

struct UkuranHewanManager
{
    
    var delegate: UkuranHewanManagerDelegate?
    let url = "\(Constant.url)/ukuran_hewan"
    
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
                    self.delegate?.didFetchUkuran(ukuranhewan: safeData)

                }
                else
                {
                    self.delegate?.didMessageUkuran(title: "Error", message: "Failed Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessageUkuran(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = UkuranHewanDataStore(ukuranHewan: nama)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageUkuran(title: "Success", message: "Success Store Data !")
                }
                else
                {
                    self.delegate?.didMessageUkuran(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageUkuran(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(nama: String, id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = UkuranHewanDataStore(ukuranHewan: nama)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageUkuran(title: "Success", message: "Success Edit Data !")
                }
                else
                {
                    self.delegate?.didMessageUkuran(title: "Error", message: "Failed Edit Data !")
                }
            }
            else
            {
                self.delegate?.didMessageUkuran(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessageUkuran(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageUkuran(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessageUkuran(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> UkuranHewan?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(UkuranHewan.self, from: data)
            let ukuranhewanData = decodedData
            
            return ukuranhewanData
        }
        catch{
            self.delegate?.didMessageUkuran(title: "Error", message: "Error While Parsing Data !")
            return nil
        }
    }
}

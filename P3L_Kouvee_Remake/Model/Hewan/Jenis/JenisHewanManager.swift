//
//  JenisHewanManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol JenisHewanManagerDelegate
{
    func didFetchJenis(jenishewan: JenisHewan)
    func didMessageJenis(title: String, message: String)
}

struct JenisHewanManager
{
    
    var delegate: JenisHewanManagerDelegate?
    let url = "\(Constant.url)/jenis_hewan"
    
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
                    self.delegate?.didFetchJenis(jenishewan: safeData)

                }
                else
                {
                    self.delegate?.didMessageJenis(title: "Error", message: "Error Fetching Data !")
                }
            }
            else
            {
                 self.delegate?.didMessageJenis(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = JenisHewanDataStore(jenisHewan: nama)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if let safeData = self.parseJson(data: data)
                {
                    self.delegate?.didFetchJenis(jenishewan: safeData)
                }
                else
                {
                    self.delegate?.didMessageJenis(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                 self.delegate?.didMessageJenis(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessageJenis(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageJenis(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                 self.delegate?.didMessageJenis(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> JenisHewan?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(JenisHewan.self, from: data)
            let jenishewanData = decodedData
            
            return jenishewanData
        }
        catch{
            self.delegate?.didMessageJenis(title: "Error", message: "Error While Parsing Data !")
            return nil
        }
    }
}

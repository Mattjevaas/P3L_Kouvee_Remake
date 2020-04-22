//
//  SupplierManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol SupplierManagerDelegate
{
    func didFetch(supplier: Supplier)
    func didMessage(title:String, message: String)
}

struct SupplierManager
{
    var delegate: SupplierManagerDelegate?
    let url = "\(Constant.url)/supplier"
    
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
                    self.delegate?.didFetch(supplier: safeData)
                    
                }
                else
                {
                    self.delegate?.didMessage(title: "Error!",message: "Error While Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String, alamat: String, telp: String, email: String)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = SupplierDataStore(namaSupplier: nama, alamat: alamat, noTelp: telp, email: email)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessage(title: "Success", message: "Success Store Data !")
                }
                else
                {
                    self.delegate?.didMessage(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessage(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessage(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> Supplier?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(Supplier.self, from: data)
            let supplierData = decodedData
            
            return supplierData
        }
        catch{
            self.delegate?.didMessage(title: "Error", message: "Error While Parsing Data !")
            return nil
        }
    }
}

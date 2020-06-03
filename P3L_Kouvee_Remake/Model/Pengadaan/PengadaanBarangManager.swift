//
//  PengadaanBarangManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 28/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire


protocol PengadaanBarangManagerDelegate
{
    func didFetchPengadaanBarang(pengadaanBarang: PengadaanBarang)
    func didMessagePengadaanBarang(title:String, message: String)
}

struct PengadaanBarangManager
{
    
    var delegate: PengadaanBarangManagerDelegate?
    let url = "\(Constant.url)/pengadaanbarang"
    
    
    
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
                    self.delegate?.didFetchPengadaanBarang(pengadaanBarang: safeData)

                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Fetching Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String, idSupplier: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        let parameter = PengadaanBarangDataStore(namaPengadaan: nama, idSupplier: idSupplier)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(nama: String, idSupplier: Int,id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/edit/\(id)"
        
        let parameter = PengadaanBarangDataStore(namaPengadaan: nama, idSupplier: idSupplier)
        
        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Success", message: "Success Store Data")
                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessagePengadaanBarang(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Delete Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func confirm_datang(id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/datang/\(id)"
        
        AF.request(urls, method: .post ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Success", message: "Success Update Data !")
                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Update Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func confirm_cetak(id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/cetak/\(id)"
        
        AF.request(urls, method: .post ,headers: header).response { response in
            
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Success", message: "Success Update Data !")
                }
                else
                {
                    self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Update Data !")
                }
            }
            else
            {
                self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func simpanSurat(id: Int)
    {
        let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/cekpdf/\(id)"
        let destination: DownloadRequest.Destination = { _, _ in
           let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
           let fileURL = documentsURL.appendingPathComponent("suratPemesanan.pdf")
           return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(urls, headers: header, to: destination).response { response in
            debugPrint(response)
        }
    }
    
    func parseJson(data: Data) -> PengadaanBarang?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(PengadaanBarang.self, from: data)
            let pengadaanBarangData = decodedData
            
            return pengadaanBarangData
        }
        catch{
            self.delegate?.didMessagePengadaanBarang(title: "Error", message: "Failed Parsing Data !")
            return nil
        }
    }
    
    
}

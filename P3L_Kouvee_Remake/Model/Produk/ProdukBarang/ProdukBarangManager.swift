//
//  ProdukBarangManager.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 22/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol ProdukBarangManagerDelegate
{
    func didFetchProdukBarang(produkBarang: ProdukBarang)
    func didMessageProdukBarang(title:String, message: String)
}

struct ProdukBarangManager
{
    var delegate: ProdukBarangManagerDelegate?
    let url = "\(Constant.url)/barang"
    
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
                    self.delegate?.didFetchProdukBarang(produkBarang: safeData)
                    
                }
                else
                {
                    self.delegate?.didMessageProdukBarang(title: "Error", message: "Failed Fetch Data !")
                }
            }
            else
            {
                self.delegate?.didMessageProdukBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func store_data(nama: String, satuan: String, jumlahProduk: String, hargaJual: String, hargaBeli: String, stokMinimal: String, image: UIImage)
    {
        //let header: HTTPHeaders = [ "Authorization" : "Bearer \(Constant.APIKEY)" , "Accept": "application/json" ]
        let urls = "\(url)/store"
        
        //let parameter = ProdukBarangDataStore(namaProduk: nama, satuan: satuan, jumlahProduk: jumlahProduk, hargaJual: hargaJual, hargaBeli: hargaBeli, stokMinimal: stokMinimal)
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters = ["namaProduk": nama, "satuan": satuan, "jumlahProduk": jumlahProduk, "hargaJual": hargaJual, "hargaBeli": hargaBeli, "stokMinimal": stokMinimal]
        
        let name = "\(Constant.randomString(length: 10)).jpg"
        
        //        AF.request(urls, method: .post, parameters: parameter ,headers: header).response { response in
        //
        //            debugPrint(response)
        //            if let data = response.data
        //            {
        //                if let safeData = self.parseJson(data: data)
        //                {
        //                    self.delegate?.didFetchProdukBarang(produkBarang: safeData)
        //                }
        //            }
        //
        //        }
        AF.upload(multipartFormData:
            { multipartFormData in
                multipartFormData.append(imgData, withName: "productPic",fileName: name, mimeType: "image/jpg")
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to: urls).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageProdukBarang(title: "Success",message: "Success Store Data!")
                }
                else
                {
                    self.delegate?.didMessageProdukBarang(title: "Error", message: "Error Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageProdukBarang(title: "Error", message: "Network Error !")
            }
            
        }
        
    }
    
    func edit_data(nama: String, satuan: String, jumlahProduk: String, hargaJual: String, hargaBeli: String, stokMinimal: String, image: UIImage, id: Int)
    {

        let urls = "\(url)/edit/\(id)"

        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters = ["namaProduk": nama, "satuan": satuan, "jumlahProduk": jumlahProduk, "hargaJual": hargaJual, "hargaBeli": hargaBeli, "stokMinimal": stokMinimal]
        
        let name = "\(Constant.randomString(length: 10)).jpg"
        
        AF.upload(multipartFormData:
            { multipartFormData in
                multipartFormData.append(imgData, withName: "productPic",fileName: name, mimeType: "image/jpg")
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to: urls).response { response in
            
            debugPrint(response)
            if let data = response.data
            {
                if self.parseJson(data: data) != nil
                {
                    self.delegate?.didMessageProdukBarang(title: "Success",message: "Success Edit Data!")
                }
                else
                {
                    self.delegate?.didMessageProdukBarang(title: "Error", message: "Error Edit Data !")
                }
            }
            else
            {
                self.delegate?.didMessageProdukBarang(title: "Error", message: "Network Error !")
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
                    self.delegate?.didMessageProdukBarang(title: "Success", message: "Success Delete Data !")
                }
                else
                {
                    self.delegate?.didMessageProdukBarang(title: "Error", message: "Error Store Data !")
                }
            }
            else
            {
                self.delegate?.didMessageProdukBarang(title: "Error", message: "Network Error !")
            }
        }
    }
    
    func parseJson(data: Data) -> ProdukBarang?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(ProdukBarang.self, from: data)
            let produkBarangData = decodedData
            
            return produkBarangData
        }
        catch{
            debugPrint(error)
            self.delegate?.didMessageProdukBarang(title: "Error", message: "Error Fetching Data !")
            return nil
        }
    }
}

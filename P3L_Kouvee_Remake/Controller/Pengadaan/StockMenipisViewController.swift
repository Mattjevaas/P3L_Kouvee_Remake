//
//  StockMenipisViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 05/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StockMenipisViewController: UIViewController {

    @IBOutlet weak var titleProduk: UILabel!
    @IBOutlet weak var tableProduk: UITableView!
    
    
    var dataProduk: [ProdukBarangData] = []
    var produkManager = ProdukBarangManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        produkManager.delegate = self
        tableProduk.dataSource = self
        produkManager.fetch_all()
    }
    

}


extension StockMenipisViewController: ProdukBarangManagerDelegate
{
    func didFetchProdukBarang(produkBarang: ProdukBarang) {
        
        dataProduk = []
        
        for produk in produkBarang.Data
        {
            let jumlah  = Int(produk.jumlahProduk)!
            let min = Int(produk.stokMinimal)!
            
            if jumlah <= min
            {
                dataProduk.append(produk)
            }
        }
        
        DispatchQueue.main.async {
            self.tableProduk.reloadData()
        }
        
        if dataProduk.count == 0
        {
            titleProduk.text = "Belum Ada Stock Menipis !"
        }
    }
    
    func didMessageProdukBarang(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
}

extension StockMenipisViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProduk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemMenipis", for: indexPath)
        
        
        cell.textLabel?.text = dataProduk[indexPath.row].namaProduk
        cell.detailTextLabel?.text = "Sisa Stock : \(dataProduk[indexPath.row].jumlahProduk)"
        
        return cell
    }
    
    
}

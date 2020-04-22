//
//  ProdukBarangViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 22/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProdukBarangViewController: UIViewController {
    
    @IBOutlet weak var produkBarangTable: UITableView!
    
    var imagesUrls: URL?
    var arrImages: [UIImage]? = []
    var filteredProdukBarang: [ProdukBarangData] = []
    var dataProdukBarang: [ProdukBarangData] = []
    var produkBarangDataSegue: ProdukBarangData?
    var produkBarangManager = ProdukBarangManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        produkBarangTable.dataSource = self
        produkBarangTable.delegate = self
        produkBarangManager.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshProdukBarangData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Items Data...")
        produkBarangTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items"
        produkBarangTable.tableHeaderView = searchController.searchBar
        produkBarangTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        produkBarangManager.fetch_all()
        
    }
    
    @objc private func refreshProdukBarangData(_ sender: Any) {
        produkBarangManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        performSegue(withIdentifier: "toAddItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditItem"
        {
            if let destinationVC = segue.destination as? ProdukBarangDetailViewController
            {
                destinationVC.produkBarangData = produkBarangDataSegue
            }
        }
    }
    
    
}

//MARK: - ProdukBarang Delegate
extension ProdukBarangViewController: ProdukBarangManagerDelegate
{
    
    func didMessageProdukBarang(title: String, message: String)
    {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchProdukBarang(produkBarang: ProdukBarang)
    {
        dataProdukBarang = []
        
        for produkBarangs in produkBarang.Data
        {
            dataProdukBarang.append(produkBarangs)
        }
        
        DispatchQueue.main.async
        {
            self.produkBarangTable.reloadData()
        }
        
        
        self.refresherController.endRefreshing()
    }
}

//MARK: - Table Data Source
extension ProdukBarangViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering
        {
            return filteredProdukBarang.count
        }
        
        return dataProdukBarang.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let produkBarangs: ProdukBarangData
        var imagesURL: URL? = nil
        
        if isFiltering
        {
            produkBarangs = filteredProdukBarang[indexPath.row]
            imagesURL = URL(string: "\(Constant.urlStorage)/\(filteredProdukBarang[indexPath.row].linkGambar)")
        }
        else
        {
            produkBarangs = dataProdukBarang[indexPath.row]
            imagesURL = URL(string: "\(Constant.urlStorage)/\(dataProdukBarang[indexPath.row].linkGambar)")
        }
        
        
        
        //image fetch
        DispatchQueue.global().async {
            guard let imagesData = try? Data(contentsOf: imagesURL!) else { return }

            let image = UIImage(data: imagesData)
            DispatchQueue.main.async {

                cell.imageCell.image = image
                cell.imageCell.layer.cornerRadius = cell.imageCell.frame.size.height / 5
            }
        }

        cell.txtOne.text = produkBarangs.namaProduk
        cell.txtTwo.text = "Stock : \(produkBarangs.jumlahProduk) / \(produkBarangs.satuan)"
        cell.txtThree.text = "Harga Jual : Rp. \(produkBarangs.hargaJual)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            if isFiltering
            {
                produkBarangManager.delete_data(id: filteredProdukBarang[indexPath.row].idProduk)
                filteredProdukBarang.remove(at: indexPath.row)
            }
            else
            {
                produkBarangManager.delete_data(id: dataProdukBarang[indexPath.row].idProduk)
                dataProdukBarang.remove(at: indexPath.row)
            }
            
            produkBarangTable.reloadData()
        }
    }
}

//MARK: - Table Delegate
extension ProdukBarangViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            produkBarangDataSegue = filteredProdukBarang[indexPath.row]
        }
        else
        {
            produkBarangDataSegue = dataProdukBarang[indexPath.row]
        }
        
        performSegue(withIdentifier: "toEditItem", sender: self)
        produkBarangTable.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Update
extension ProdukBarangViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredProdukBarang = dataProdukBarang.filter
            { (produkBarang: ProdukBarangData) -> Bool in
                return produkBarang.namaProduk.lowercased().contains(searchText.lowercased())
        }
        
        produkBarangTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

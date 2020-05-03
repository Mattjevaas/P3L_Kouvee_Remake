//
//  ProdukLayananViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProdukLayananViewController: UIViewController {
    
    @IBOutlet weak var produkLayananTable: UITableView!
    
    var filteredprodukLayanan: [HargaLayananData] = []
    var dataprodukLayanan: [HargaLayananData] = []
    var dataprodukLayananForSegue: HargaLayananData?
    var produkLayananManager = HargaLayananManager()
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    
    var menuOut = false
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        produkLayananTable.dataSource = self
        produkLayananTable.delegate = self
        produkLayananManager.delegate = self
        produkLayananTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        refresherController.addTarget(self, action: #selector(refreshprodukLayananData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Service Data...")
        produkLayananTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Service"
        produkLayananTable.tableHeaderView = searchController.searchBar
        
        produkLayananManager.fetch_all()
        
    }
    
    @objc private func refreshprodukLayananData(_ sender: Any) {
        produkLayananManager.fetch_all()
    }
    
    @IBAction func btnMenu(_ sender: Any) {
        
        if menuOut == false
        {
            leading.constant = 220
            trailing.constant = 220
            menuOut = true
        }
        else
        {
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "toAddService", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditService"
        {
            if let destinationVC = segue.destination as? ProdukLayananDetailViewController{
                destinationVC.dataHargaLayanan = dataprodukLayananForSegue
            }
        }
    }
}


//MARK: -Table View Data Source
extension ProdukLayananViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
            return filteredprodukLayanan.count
        }
        
        return dataprodukLayanan.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let produkLayanan: HargaLayananData
        let image = UIImage(systemName: "hand.raised.fill")?.withTintColor(UIColor.black)
        
        if isFiltering{
            produkLayanan = filteredprodukLayanan[indexPath.row]
        }
        else{
            produkLayanan = dataprodukLayanan[indexPath.row]
        }
        
        cell.txtOne.text = produkLayanan.idLayanan.namaLayanan
        cell.txtTwo.text = "\(produkLayanan.idJenisHewan.jenisHewan) - \(produkLayanan.idUkuranHewan.ukuranHewan)"
        cell.txtThree.text = "Harga : \(produkLayanan.hargaLayanan)"
        cell.imageCell.image = image
        
        
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
                produkLayananManager.delete_data(id: filteredprodukLayanan[indexPath.row].idHargaLayanan)
                filteredprodukLayanan.remove(at: indexPath.row)
            }
            else
            {
                produkLayananManager.delete_data(id: dataprodukLayanan [indexPath.row].idHargaLayanan)
                dataprodukLayanan.remove(at: indexPath.row)
            }
        }
    }
    
}

//MARK: -Table View Delegate
extension ProdukLayananViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            dataprodukLayananForSegue = filteredprodukLayanan[indexPath.row]
        }
        else
        {
            dataprodukLayananForSegue = dataprodukLayanan[indexPath.row]
        }
        
        
        performSegue(withIdentifier: "toEditService", sender: self)
        produkLayananTable.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: -Produk Layanan Delegate
//extension ProdukLayananViewController: ProdukLayananManagerDelegate
//{
//    func didMessage(title: String, message: String)
//    {
//         Constant.showAlert(title: title, message: message, sender: self, back: false)
//    }
//
//    func didFetch(produkLayanan: ProdukLayanan)
//    {
//        dataprodukLayanan = []
//
//        for produkLayanans in produkLayanan.Data
//        {
//            dataprodukLayanan.append(produkLayanans)
//        }
//
//        DispatchQueue.main.async
//            {
//                self.produkLayananTable.reloadData()
//        }
//
//        self.refresherController.endRefreshing()
//
//    }
//
//}

//MARK: - Harga Layanan Delegate
extension ProdukLayananViewController: HargaLayananManagerDelegate
{
    func didFetchHargaLayanan(hargalayanan: HargaLayanan) {
        dataprodukLayanan = []
        
        for hargaLayanans in hargalayanan.Data
        {
            dataprodukLayanan.append(hargaLayanans)
        }
        
        DispatchQueue.main.async
            {
                self.produkLayananTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
    
    func didMessageHargaLayanan(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    
}

//MARK: -SearchBar
extension ProdukLayananViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredprodukLayanan = dataprodukLayanan.filter
            { (produkLayanan: HargaLayananData) -> Bool in
                return produkLayanan.idLayanan.namaLayanan.lowercased().contains(searchText.lowercased())
        }
        
        produkLayananTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


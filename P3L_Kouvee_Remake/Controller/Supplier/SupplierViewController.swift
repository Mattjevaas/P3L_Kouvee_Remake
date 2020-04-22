//
//  SupplierViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SupplierViewController: UIViewController
{
    
    @IBOutlet weak var supplierTable: UITableView!
    
    var filteredSupplier: [SupplierData] = []
    var dataSupplier: [SupplierData] = []
    var dataSupplierForSegue: SupplierData?
    var supplierManager = SupplierManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supplierTable.dataSource = self
        supplierTable.delegate = self
        supplierManager.delegate = self
        
        supplierTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        refresherController.addTarget(self, action: #selector(refreshSupplierData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Supplier Data...")
        supplierTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Suppliers"
        supplierTable.tableHeaderView = searchController.searchBar
        
        supplierManager.fetch_all()
        
    }
    
    @objc private func refreshSupplierData(_ sender: Any) {
        supplierManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "toAddSupplier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditSupplier"
        {
            if let destinationVC = segue.destination as? SupplierDetailViewController{
                destinationVC.dataSupplier = dataSupplierForSegue
            }
        }
    }
}


//MARK: -Table View Data Source
extension SupplierViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
            return filteredSupplier.count
        }
        
        return dataSupplier.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let supplier: SupplierData
        let image = UIImage(systemName: "person.2.fill")?.withTintColor(UIColor.black)
        
        if isFiltering{
            supplier = filteredSupplier[indexPath.row]
        }
        else{
            supplier = dataSupplier[indexPath.row]
        }
        
        cell.txtOne.text = supplier.namaSupplier
        cell.txtTwo.text = "No Telp : \(supplier.noTelp)"
        cell.txtThree.text = "Alamat : \(supplier.alamat)"
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
                supplierManager.delete_data(id: filteredSupplier[indexPath.row].idSupplier)
                filteredSupplier.remove(at: indexPath.row)
            }
            else
            {
                supplierManager.delete_data(id: dataSupplier[indexPath.row].idSupplier)
                dataSupplier.remove(at: indexPath.row)
            }
            
            supplierTable.reloadData()
        }
    }
    
}

//MARK: -Table View Delegate
extension SupplierViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            dataSupplierForSegue = filteredSupplier[indexPath.row]
        }
        else
        {
            dataSupplierForSegue = dataSupplier[indexPath.row]
        }
        
        
        performSegue(withIdentifier: "toEditSupplier", sender: self)
        supplierTable.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: -Supplier Delegate
extension SupplierViewController: SupplierManagerDelegate
{
    func didMessage(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetch(supplier: Supplier)
    {
        dataSupplier = []
        
        for suppliers in supplier.Data
        {
            dataSupplier.append(suppliers)
        }
        
        DispatchQueue.main.async
        {
            self.supplierTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
        
    }
}

//MARK: -SearchBar
extension SupplierViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredSupplier = dataSupplier.filter
            { (supplier: SupplierData) -> Bool in
                return supplier.namaSupplier.lowercased().contains(searchText.lowercased())
        }
        
        supplierTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

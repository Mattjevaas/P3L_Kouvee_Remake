//
//  UkuranHewanViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UkuranHewanViewController: UIViewController {

    @IBOutlet weak var ukuranTable: UITableView!
    
    var filteredUkuran: [UkuranHewanData] = []
    var dataUkuran: [UkuranHewanData] = []
    var ukuranDataSegue: UkuranHewanData?
    var ukuranManager = UkuranHewanManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ukuranTable.dataSource = self
        ukuranTable.delegate = self
        ukuranManager.delegate = self
       
        refresherController.addTarget(self, action: #selector(refreshHewanData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Sizes Data...")
        ukuranTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sizes"
        ukuranTable.tableHeaderView = searchController.searchBar
        ukuranTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        ukuranManager.fetch_all()
        
    }
    
    @objc private func refreshHewanData(_ sender: Any) {
        ukuranManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        performSegue(withIdentifier: "toAddUkuran", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditUkuran"
        {
            if let destinationVC = segue.destination as? UkuranHewanDetailViewController
            {
                destinationVC.ukuranData = ukuranDataSegue
            }
        }
    }
}

extension UkuranHewanViewController: UkuranHewanManagerDelegate
{
    func didMessageUkuran(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchUkuran(ukuranhewan: UkuranHewan)
    {
        dataUkuran = []
        
        for sizes in ukuranhewan.Data
        {
            dataUkuran.append(sizes)
        }
        
        DispatchQueue.main.async
        {
            self.ukuranTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
}

//MARK: - Table Data Source
extension UkuranHewanViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isFiltering
        {
            return filteredUkuran.count
        }
        
        return dataUkuran.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let sizes: UkuranHewanData
        let image = UIImage(systemName: "square.stack.3d.up.fill")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            sizes = filteredUkuran[indexPath.row]
        }
        else
        {
            sizes = dataUkuran[indexPath.row]
        }
        
        cell.txtOne.text = sizes.ukuranHewan
        cell.txtTwo.text = "ID Ukuran : \(sizes.idUkuranHewan)"
        cell.txtThree.isHidden = true
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
                ukuranManager.delete_data(id: filteredUkuran[indexPath.row].idUkuranHewan)
                filteredUkuran.remove(at: indexPath.row)
            }
            else
            {
                ukuranManager.delete_data(id: dataUkuran[indexPath.row].idUkuranHewan)
                dataUkuran.remove(at: indexPath.row)
            }
            
            ukuranTable.reloadData()
        }
    }
}

//MARK: - Table Delegate
extension UkuranHewanViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            ukuranDataSegue = filteredUkuran[indexPath.row]
        }
        else
        {
            ukuranDataSegue = dataUkuran[indexPath.row]
        }
        
        performSegue(withIdentifier: "toEditUkuran", sender: self)
        ukuranTable.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Update
extension UkuranHewanViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredUkuran = dataUkuran.filter
        { (ukuranhewan: UkuranHewanData) -> Bool in
            return ukuranhewan.ukuranHewan.lowercased().contains(searchText.lowercased())
        }
      
        ukuranTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}



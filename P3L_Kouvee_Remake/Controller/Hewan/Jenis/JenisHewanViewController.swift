//
//  JenisHewanViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class JenisHewanViewController: UIViewController {
    
    @IBOutlet weak var jenisTable: UITableView!
    
    var filteredJenis: [JenisHewanData] = []
    var dataJenis: [JenisHewanData] = []
    var jenisDataSegue: JenisHewanData?
    var jenisManager = JenisHewanManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        jenisTable.dataSource = self
        jenisTable.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshHewanData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Sizes Data...")
        
        jenisTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sizes"
        jenisTable.tableHeaderView = searchController.searchBar
        
        jenisTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        jenisManager.delegate = self
        jenisManager.fetch_all()
        
    }
    
    @objc private func refreshHewanData(_ sender: Any) {
        jenisManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        performSegue(withIdentifier: "toAddJenis", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditJenis"
        {
            if let destinationVC = segue.destination as? JenisHewanDetailViewController
            {
                destinationVC.jenisData = jenisDataSegue
            }
        }
    }
}

extension JenisHewanViewController: JenisHewanManagerDelegate
{
    func didMessageJenis(title: String, message: String)
    {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchJenis(jenishewan: JenisHewan)
    {
        dataJenis = []
        
        for sizes in jenishewan.Data
        {
            dataJenis.append(sizes)
        }
        
        DispatchQueue.main.async
        {
            self.jenisTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
}

//MARK: - Table Data Source
extension JenisHewanViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering
        {
            return filteredJenis.count
        }
        
        return dataJenis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let sizes: JenisHewanData
        let image = UIImage(systemName: "ant.circle")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            sizes = filteredJenis[indexPath.row]
        }
        else
        {
            sizes = dataJenis[indexPath.row]
        }
        
        cell.txtOne.text = sizes.jenisHewan
        cell.txtTwo.text = "ID Jenis : \(sizes.idJenisHewan)"
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
                jenisManager.delete_data(id: filteredJenis[indexPath.row].idJenisHewan)
                filteredJenis.remove(at: indexPath.row)
            }
            else
            {
                jenisManager.delete_data(id: dataJenis[indexPath.row].idJenisHewan)
                dataJenis.remove(at: indexPath.row)
            }
            
            jenisTable.reloadData()
        }
    }
}

//MARK: - Table Delegate
extension JenisHewanViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            jenisDataSegue = filteredJenis[indexPath.row]
        }
        else
        {
            jenisDataSegue = dataJenis[indexPath.row]
        }
        
        performSegue(withIdentifier: "toEditJenis", sender: self)
        jenisTable.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Update
extension JenisHewanViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredJenis = dataJenis.filter
            { (jenishewan: JenisHewanData) -> Bool in
                return jenishewan.jenisHewan.lowercased().contains(searchText.lowercased())
        }
        
        jenisTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}




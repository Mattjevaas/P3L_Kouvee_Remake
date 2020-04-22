//
//  HewanViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HewanViewController: UIViewController {

    @IBOutlet weak var hewanTable: UITableView!
    
    var menuOut = false
    @IBOutlet weak var hewanLeading: NSLayoutConstraint!
    @IBOutlet weak var hewanTrailing: NSLayoutConstraint!
    var filteredHewan: [HewanData] = []
    var dataHewan: [HewanData] = []
    var hewanDataSegue: HewanData?
    var hewanManager = HewanManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hewanTable.dataSource = self
        hewanTable.delegate = self
        hewanManager.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshHewanData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Animals Data...")
        hewanTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Animals"
        hewanTable.tableHeaderView = searchController.searchBar
        hewanTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        hewanManager.fetch_all()
    }
    
    @objc private func refreshHewanData(_ sender: Any) {
        hewanManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        performSegue(withIdentifier: "toAddAnimal", sender: self)
    }
    
    @IBAction func btnMenu(_ sender: Any) {
        
        if menuOut == false
        {
            hewanLeading.constant = 175
            hewanTrailing.constant = 175
            menuOut = true
        }
        else
        {
            hewanLeading.constant = 0
            hewanTrailing.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditAnimal"
        {
            if let destinationVC = segue.destination as? HewanDetailViewController
            {
                destinationVC.hewanData = hewanDataSegue
            }
        }
    }
}

//MARK: - Hewan Delegate
extension HewanViewController: HewanManagerDelegate
{
    func didMessageHewan(title: String, message: String)
    {
        Constant.showAlert(title: title, message: message, sender: self, back: true)
    }
    
    func didFetchHewan(hewan: Hewan)
    {
        dataHewan = []
        
        for hewans in hewan.Data
        {
            dataHewan.append(hewans)
        }
        
        DispatchQueue.main.async
        {
            self.hewanTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
}

//MARK: - Table Data Source
extension HewanViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isFiltering
        {
            return filteredHewan.count
        }
        
        return dataHewan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let hewans: HewanData
        let image = UIImage(systemName: "hare.fill")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            hewans = filteredHewan[indexPath.row]
        }
        else
        {
            hewans = dataHewan[indexPath.row]
        }
        
        cell.txtOne.text = hewans.namaHewan
        cell.txtTwo.text = "Jenis Hewan : \(hewans.idJenisHewan.jenisHewan)"
        cell.txtThree.text = "Nama Pemilik : \(hewans.idCustomer_Member.namaCustomer)"
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
                hewanManager.delete_data(id: filteredHewan[indexPath.row].idHewan)
                filteredHewan.remove(at: indexPath.row)
            }
            else
            {
                hewanManager.delete_data(id: dataHewan[indexPath.row].idHewan)
                dataHewan.remove(at: indexPath.row)
            }
            
            hewanTable.reloadData()
        }
    }
}

//MARK: - Table Delegate
extension HewanViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            hewanDataSegue = filteredHewan[indexPath.row]
        }
        else
        {
            hewanDataSegue = dataHewan[indexPath.row]
        }
        
        performSegue(withIdentifier: "toEditAnimal", sender: self)
        hewanTable.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Update
extension HewanViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredHewan = dataHewan.filter
        { (hewan: HewanData) -> Bool in
            return hewan.namaHewan.lowercased().contains(searchText.lowercased())
        }
      
        hewanTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

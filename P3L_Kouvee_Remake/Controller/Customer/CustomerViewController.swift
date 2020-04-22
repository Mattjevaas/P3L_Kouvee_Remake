//
//  CustomerViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {
    
    var filteredCustomer: [CustomerData] = []
    var dataCustomer: [CustomerData] = []
    var customerManager = CustomerManager()
    var dataForSegueCustomer: CustomerData?
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    
    @IBOutlet weak var tableCustomer: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableCustomer.dataSource = self
        tableCustomer.delegate = self
        customerManager.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshCustomerData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Customer Data...")
        tableCustomer.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Customers"
        tableCustomer.tableHeaderView = searchController.searchBar
        tableCustomer.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        customerManager.fetch_all()
        
    }
    
    
    @objc private func refreshCustomerData(_ sender: Any) {
        customerManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        dataForSegueCustomer = nil
        performSegue(withIdentifier: "toAddCustomer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toEditCustomer"
        {
            if let destinationVC = segue.destination as? CustomerDetailViewController
            {
                destinationVC.dataForSegueCustomer = dataForSegueCustomer
            }
        }
    }
}

//MARK: - CustomerManagerDelegate

extension CustomerViewController: CustomerManagerDelegate
{
    func didMessage(title: String, message: String)
    {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetch(customer: Customer)
    {
        dataCustomer = []
        
        for customers in customer.Data
        {
            dataCustomer.append(customers)
        }
        
        DispatchQueue.main.async
        {
            self.tableCustomer.reloadData()
        }
        
        self.refresherController.endRefreshing()
        
    }
    
}


//MARK: - TableDataSource

extension CustomerViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if isFiltering
        {
            return filteredCustomer.count
        }
        
        return dataCustomer.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let customers: CustomerData
        let image = UIImage(systemName: "person.fill")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            customers = filteredCustomer[indexPath.row]
        }
        else
        {
            customers = dataCustomer[indexPath.row]
        }
        
        cell.txtOne.text = "\(customers.namaCustomer)"
        cell.txtTwo.text = "No Telp : \(customers.noTelp)"
        cell.txtThree.text = "Alamat : \(customers.alamat)"
        cell.imageCell?.image = image
        
        
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
                customerManager.delete_data(id: filteredCustomer[indexPath.row].idCustomer_Member)
                filteredCustomer.remove(at: indexPath.row)
            }
            else
            {
                customerManager.delete_data(id: dataCustomer[indexPath.row].idCustomer_Member)
                dataCustomer.remove(at: indexPath.row)
            }
            
            tableCustomer.reloadData()
        }
    }
    
}


//MARK: - TableViewDelegate

extension CustomerViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            dataForSegueCustomer = filteredCustomer[indexPath.row]
        }
        else
        {
            dataForSegueCustomer = dataCustomer[indexPath.row]
        }
        
        performSegue(withIdentifier: "toEditCustomer", sender: self)
        tableCustomer.deselectRow(at: indexPath, animated: true)
        
    }
    
}


//MARK: - SearchBarFunction

extension CustomerViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredCustomer = dataCustomer.filter
            { (customer: CustomerData) -> Bool in
                return customer.namaCustomer.lowercased().contains(searchText.lowercased())
        }
        
        tableCustomer.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}




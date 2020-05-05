//
//  PengadaanBarangViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 29/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PengadaanBarangViewController: UIViewController {
    
    @IBOutlet weak var pengadaanBarangTable: UITableView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtNamaRestock: UITextField!
    @IBOutlet weak var pickerSupplier: UIPickerView!
    
    var menuOut = false
    var filteredPengadaanBarang: [PengadaanBarangData] = []
    var dataPengadaanBarang: [PengadaanBarangData] = []
    var pengadaanBarangDataSegue: PengadaanBarangData?
    var pengadaanBarangManager = PengadaanBarangManager()
    
    var idPengadaan: Int = -1
    var supplierManager = SupplierManager()
    var dataSupplier: [SupplierData] = []
    var supplierValue = 0
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius = btnSave.frame.size.height / 5
        
        pengadaanBarangManager.delegate = self
        pengadaanBarangTable.dataSource = self
        pengadaanBarangTable.delegate = self
        supplierManager.delegate = self
        pickerSupplier.dataSource = self
        pickerSupplier.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshPengadaanBarangData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Restocks Data...")
        
        pengadaanBarangTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restock"
        pengadaanBarangTable.tableHeaderView = searchController.searchBar
        
        
        pengadaanBarangTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        pengadaanBarangManager.fetch_all()
        supplierManager.fetch_all()
        
        
    }
    
    @objc private func refreshPengadaanBarangData(_ sender: Any) {
        pengadaanBarangManager.fetch_all()
    }
    
    @IBAction func btnAdd(_ sender: Any)
    {
        self.btnSave.setTitle("Save", for: .normal)
        txtNamaRestock.text = ""
        pickerSupplier.selectRow(0, inComponent: 0, animated: false)
        
        if menuOut == false
        {
            top.constant = -360
            bottom.constant = -360
            menuOut = true
        }
        else
        {
            top.constant = 0
            bottom.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        
        if sender.currentTitle == "Save"
        {
            if txtNamaRestock.text != ""
            {
                pengadaanBarangManager.store_data(nama: txtNamaRestock.text!, idSupplier: supplierValue)
            }
        }
        else
        {
            pengadaanBarangManager.edit_data(nama: txtNamaRestock.text!, idSupplier: supplierValue, id: idPengadaan)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPengadaan"
        {
            if let destinationVC = segue.destination as? PengadaanBarangDetailViewController
            {
                destinationVC.pengadaanBarangData = pengadaanBarangDataSegue
            }
        }
    }
}

//MARK: - PengadaanBarang Delegate
extension PengadaanBarangViewController: PengadaanBarangManagerDelegate
{
    func didMessagePengadaanBarang(title: String, message: String) {
        
        if title == "Success"
        {
            pengadaanBarangManager.fetch_all()
            
            top.constant = 0
            bottom.constant = 0
            menuOut = false
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
        else
        {
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
        
    }
    
    func didFetchPengadaanBarang(pengadaanBarang: PengadaanBarang)
    {
        dataPengadaanBarang = []
        
        for pengadaanBarangs in pengadaanBarang.Data
        {
            dataPengadaanBarang.append(pengadaanBarangs)
        }
        
        DispatchQueue.main.async
            {
                self.pengadaanBarangTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
    
}

//MARK: - Table Data Source
extension PengadaanBarangViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering
        {
            return filteredPengadaanBarang.count
        }
        
        return dataPengadaanBarang.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let pengadaanBarangs: PengadaanBarangData
        let image = UIImage(systemName: "cube.box.fill")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            pengadaanBarangs = filteredPengadaanBarang[indexPath.row]
        }
        else
        {
            pengadaanBarangs = dataPengadaanBarang[indexPath.row]
        }
        
        cell.txtOne.text = pengadaanBarangs.namaPengadaan
        cell.txtTwo.text = "Nama Supplier : \(pengadaanBarangs.idSupplier.namaSupplier)"
        cell.txtThree.text = "Tanggal : \(pengadaanBarangs.tglPengadaan)"
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
                pengadaanBarangManager.delete_data(id: filteredPengadaanBarang[indexPath.row].idPengadaanBarang)
                filteredPengadaanBarang.remove(at: indexPath.row)
            }
            else
            {
                pengadaanBarangManager.delete_data(id: dataPengadaanBarang[indexPath.row].idPengadaanBarang)
                dataPengadaanBarang.remove(at: indexPath.row)
            }
            
            pengadaanBarangTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let add = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion ) in
            
            self.btnSave.setTitle("Edit", for: .normal)
            self.top.constant = -360
            self.bottom.constant = -360
            self.menuOut = true
            
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            var indexes = 0
            
            if self.isFiltering
            {
                self.idPengadaan = self.filteredPengadaanBarang[indexPath.row].idPengadaanBarang
                self.txtNamaRestock.text = self.filteredPengadaanBarang[indexPath.row].namaPengadaan
                
                for item in self.dataSupplier
                {
                    if item.idSupplier == self.filteredPengadaanBarang[indexPath.row].idSupplier.idSupplier
                    {
                        break
                    }
                    
                    indexes += 1
                }
                
                self.pickerSupplier.selectRow(indexes, inComponent: 0, animated: false)
            }
            else
            {
                self.idPengadaan = self.dataPengadaanBarang[indexPath.row].idPengadaanBarang
                
                self.txtNamaRestock.text = self.dataPengadaanBarang [indexPath.row].namaPengadaan
                
                for item in self.dataSupplier
                {
                    if item.idSupplier == self.dataPengadaanBarang[indexPath.row].idSupplier.idSupplier
                    {
                        break
                    }
                    
                    indexes += 1
                }
                
                self.pickerSupplier.selectRow(indexes, inComponent: 0, animated: false)
            }
            
            self.supplierValue = self.dataSupplier[indexes].idSupplier
            self.pengadaanBarangTable.reloadData()
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion ) in
            if self.isFiltering
            {
                self.pengadaanBarangManager.delete_data(id: self.filteredPengadaanBarang[indexPath.row].idPengadaanBarang)
                self.filteredPengadaanBarang.remove(at: indexPath.row)
            }
            else
            {
                self.pengadaanBarangManager.delete_data(id: self.dataPengadaanBarang[indexPath.row].idPengadaanBarang)
                self.dataPengadaanBarang.remove(at: indexPath.row)
            }
            
            self.pengadaanBarangTable.reloadData()
        }
        
        let config = UISwipeActionsConfiguration(actions: [add, delete])
        return config
    }
}

//MARK: - Table Delegate
extension PengadaanBarangViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            pengadaanBarangDataSegue = filteredPengadaanBarang[indexPath.row]
        }
        else
        {
            pengadaanBarangDataSegue = dataPengadaanBarang[indexPath.row]
        }
        
        performSegue(withIdentifier: "toDetailPengadaan", sender: self)
        pengadaanBarangTable.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Update
extension PengadaanBarangViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredPengadaanBarang = dataPengadaanBarang.filter
            { (pengadaanBarang: PengadaanBarangData) -> Bool in
                return pengadaanBarang.namaPengadaan.lowercased().contains(searchText.lowercased())
        }
        
        pengadaanBarangTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

//MARK: - Supplier Delegate

extension PengadaanBarangViewController: SupplierManagerDelegate
{
    func didFetch(supplier: Supplier) {
        
        dataSupplier = []
        
        for suppliers in supplier.Data
        {
            dataSupplier.append(suppliers)
        }
        
        DispatchQueue.main.async
            {
                self.pickerSupplier.reloadAllComponents()
        }
        
        supplierValue = dataSupplier[0].idSupplier
    }
    
    func didMessage(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
}

//MARK: - Picker Data Source
extension PengadaanBarangViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        dataSupplier.count
    }
    
}

//MARK: - Picker Delegate
extension PengadaanBarangViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return dataSupplier[row].namaSupplier
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        supplierValue = dataSupplier[row].idSupplier
    }
}

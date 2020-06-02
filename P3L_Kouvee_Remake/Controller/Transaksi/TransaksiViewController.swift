//
//  TransaksiViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransaksiViewController: UIViewController {
    
    
    @IBOutlet weak var jenisSegmented: UISegmentedControl!
    @IBOutlet weak var pickerHewan: UIPickerView!
    @IBOutlet weak var transaksiTable: UITableView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnGuest: UIButton!
    
    var menuOut = false
    var filteredTransaksi: [TransaksiData] = []
    var transaksiData: [TransaksiData] = []
    var transaksiManager = TransaksiManager()
    var transaksiValue: Int = 0
    
    var dataForSegue: TransaksiData? = nil
    var hewanValue: Int = 0
    var hewanData: [HewanData] = []
    var hewanManager = HewanManager()
    
    var searchController = UISearchController(searchResultsController: nil)
    let refresherController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius = btnSave.frame.size.height / 5
        btnGuest.layer.cornerRadius = btnGuest.frame.size.height / 5
        btnGuest.backgroundColor = UIColor.red
        
        transaksiTable.delegate = self
        transaksiTable.dataSource = self
        transaksiManager.delegate = self
        pickerHewan.delegate = self
        pickerHewan.dataSource = self
        hewanManager.delegate = self
        
        refresherController.addTarget(self, action: #selector(refreshPengadaanBarangData(_:)), for: .valueChanged)
        refresherController.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresherController.attributedTitle = NSAttributedString(string: "Fetching Transaction Data...")
        transaksiTable.refreshControl = refresherController
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Transaction"
        transaksiTable.tableHeaderView = searchController.searchBar
        
        transaksiTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        transaksiManager.fetch_all()
        hewanManager.fetch_all()
    }
    
    @objc private func refreshPengadaanBarangData(_ sender: Any) {
        transaksiManager.fetch_all()
    }
    
    @IBAction func btnAddTransaksi(_ sender: Any) {
        
        btnSave.setTitle("Save", for: .normal)
        jenisSegmented.selectedSegmentIndex = 0
        pickerHewan.isHidden = false
        pickerHewan.selectRow(0, inComponent: 0, animated: false)
        hewanValue = hewanData[0].idHewan
        btnGuest.backgroundColor = UIColor.red
        
        
        if menuOut == false
        {
            top.constant = -290
            bottom.constant = -290
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
    
    @IBAction func btnGuest(_ sender: Any)
    {
        if btnGuest.backgroundColor == UIColor.red
        {
            hewanValue = -1
            btnGuest.backgroundColor = UIColor.green
            pickerHewan.isHidden = true
        }
        else
        {
            btnGuest.backgroundColor = UIColor.red
            pickerHewan.isHidden = false
            pickerHewan.selectRow(0, inComponent: 0, animated: false)
            hewanValue = hewanData[0].idHewan
        }
    }
    
    @IBAction func btnStore(_ sender: UIButton) {
        
        if sender.currentTitle == "Save"
        {
            if hewanValue != -1
            {
                let jenis = jenisSegmented.titleForSegment(at: jenisSegmented.selectedSegmentIndex)!
                transaksiManager.store_data(nama: jenis, idHewan: hewanValue)
                
                transaksiManager.fetch_all()
            }
            else
            {
                let jenis = jenisSegmented.titleForSegment(at: jenisSegmented.selectedSegmentIndex)!
                transaksiManager.store_data(nama: jenis, idHewan: nil)
                
                transaksiManager.fetch_all()
            }
        }
        else
        {
            if hewanValue != -1
            {
                let jenis = jenisSegmented.titleForSegment(at: jenisSegmented.selectedSegmentIndex)!
                transaksiManager.edit_data(nama: jenis, idHewan: hewanValue, id: transaksiValue)
                
                transaksiManager.fetch_all()
            }
            else
            {
                let jenis = jenisSegmented.titleForSegment(at: jenisSegmented.selectedSegmentIndex)!
                transaksiManager.edit_data(nama: jenis, idHewan: nil, id: transaksiValue)
                
                transaksiManager.fetch_all()
            }
        }
        
    }
}


//MARK: - Transaksi Delegate

extension TransaksiViewController: TransaksiManagerDelegate
{
    func didFetchTransaksi(transaksi: Transaksi) {
        
        transaksiData = []
        
        for trans in transaksi.Data
        {
            if trans != nil
            {
                transaksiData.append(trans!)
            }
            
        }
        
        DispatchQueue.main.async {
            self.transaksiTable.reloadData()
        }
        
        self.refresherController.endRefreshing()
    }
    
    func didMessageTransaksi(title: String, message: String) {
        
        if title == "Success"
        {
            transaksiManager.fetch_all()
            
            top.constant = 0
            bottom.constant = 0
            menuOut = false
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
        }
        
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
}

//MARK: - Hewan Delegate
extension TransaksiViewController: HewanManagerDelegate
{
    func didFetchHewan(hewan: Hewan) {
        
        hewanData = []
        
        for animal in hewan.Data
        {
            hewanData.append(animal)
        }
        
        hewanValue = hewanData[0].idHewan
        
        DispatchQueue.main.async {
            self.pickerHewan.reloadAllComponents()
        }
        
        
    }
    
    func didMessageHewan(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
}

//MARK: - Table Data Source & Delegate

extension TransaksiViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering
        {
            return filteredTransaksi.count
        }
        
        return transaksiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCell
        
        let image = UIImage(systemName: "cart.fill.badge.plus")?.withTintColor(UIColor.black)
        
        if isFiltering
        {
            if filteredTransaksi[indexPath.row].jenisTransaksi == "Layanan"
            {
                cell.txtOne.text = "LY - \(filteredTransaksi[indexPath.row].idTransaksiPembayaran)"
            }
            else
            {
                cell.txtOne.text = "PR - \(filteredTransaksi[indexPath.row].idTransaksiPembayaran)"
            }
            
            if filteredTransaksi[indexPath.row].idHewan != nil
            {
                cell.txtTwo.text = "\(filteredTransaksi[indexPath.row].idHewan?.idCustomer_Member.namaCustomer ?? "") (\(filteredTransaksi[indexPath.row].idHewan?.namaHewan ?? "") - \(filteredTransaksi[indexPath.row].idHewan?.idJenisHewan.jenisHewan ?? ""))"
            }
            else
            {
                cell.txtTwo.text = "Guest"
            }
            
            cell.txtThree.text = filteredTransaksi[indexPath.row].statusLunas
        }
        else
        {
            if transaksiData[indexPath.row].jenisTransaksi == "Layanan"
            {
                cell.txtOne.text = "LY - \(transaksiData[indexPath.row].idTransaksiPembayaran)"
            }
            else
            {
                cell.txtOne.text = "PR - \(transaksiData[indexPath.row].idTransaksiPembayaran)"
            }
            
            if transaksiData[indexPath.row].idHewan != nil
            {
                cell.txtTwo.text = "\(transaksiData[indexPath.row].idHewan?.idCustomer_Member.namaCustomer ?? "") (\(transaksiData[indexPath.row].idHewan?.namaHewan ?? "") - \(transaksiData[indexPath.row].idHewan?.idJenisHewan.jenisHewan ?? ""))"
            }
            else
            {
                cell.txtTwo.text = "Guest"
            }
            
            cell.txtThree.text = transaksiData[indexPath.row].statusLunas
        }
        
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
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let add = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion ) in
            
            self.btnSave.setTitle("Edit", for: .normal)
            self.top.constant = -290
            self.bottom.constant = -290
            self.menuOut = true
            
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            if self.isFiltering
            {
                if self.filteredTransaksi[indexPath.row].jenisTransaksi == "Layanan"
                {
                    self.jenisSegmented.selectedSegmentIndex = 0
                }
                else
                {
                    self.jenisSegmented.selectedSegmentIndex = 1
                }
                
                var index = 0
                
                for data in self.filteredTransaksi
                {
                    if data.idHewan?.idHewan == self.filteredTransaksi[indexPath.row].idHewan?.idHewan
                    {
                        self.hewanValue = self.hewanData[index].idHewan
                        break
                    }
                    else
                    {
                        self.hewanValue = -1
                    }
                    
                    index += 1
                }
                
                if self.hewanValue == -1
                {
                    self.pickerHewan.isHidden = true
                    self.btnGuest.backgroundColor = UIColor.green
                }
                else
                {
                    self.pickerHewan.isHidden = false
                    self.btnGuest.backgroundColor = UIColor.red
                }
                
                self.pickerHewan.selectRow(index, inComponent: 0, animated: false)
            }
            else
            {
                if self.transaksiData[indexPath.row].jenisTransaksi == "Layanan"
                {
                    self.jenisSegmented.selectedSegmentIndex = 0
                }
                else
                {
                    self.jenisSegmented.selectedSegmentIndex = 1
                }
                
                var index = 0
                
                for data in self.hewanData
                {
                    if data.idHewan == self.transaksiData[indexPath.row].idHewan?.idHewan
                    {
                        self.hewanValue = self.hewanData[index].idHewan
                        break
                    }
                    else
                    {
                        self.hewanValue = -1
                    }
                    
                    index += 1
                }
                
                if self.hewanValue == -1
                {
                    self.pickerHewan.isHidden = true
                    self.btnGuest.backgroundColor = UIColor.green
                }
                else
                {
                    self.pickerHewan.isHidden = false
                    self.btnGuest.backgroundColor = UIColor.red
                }
                
                self.pickerHewan.selectRow(index, inComponent: 0, animated: false)
            }
            
            self.transaksiValue = self.transaksiData[indexPath.row].idTransaksiPembayaran
            self.transaksiTable.reloadData()
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion ) in
            if self.isFiltering
            {
                self.transaksiManager.delete_data(id: self.filteredTransaksi[indexPath.row].idTransaksiPembayaran)
                self.filteredTransaksi.remove(at: indexPath.row)
            }
            else
            {
                self.transaksiManager.delete_data(id: self.transaksiData[indexPath.row].idTransaksiPembayaran)
                self.transaksiData.remove(at: indexPath.row)
            }
            
            self.transaksiTable.reloadData()
        }
        
        let config = UISwipeActionsConfiguration(actions: [add, delete])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        dataForSegue = transaksiData[indexPath.row]
        
        if transaksiData[indexPath.row].jenisTransaksi == "Layanan"
        {
            performSegue(withIdentifier: "toRincianLayanan", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "toRincianProduk", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toRincianLayanan"
        {
            if let destinationVC = segue.destination as? RincianLayananViewController
            {
                destinationVC.transaksiData = dataForSegue
            }
        }
        else
        {
            if let destinationVC = segue.destination as? RincianProdukViewController
            {
                destinationVC.transaksiData = dataForSegue
            }
        }
    }
}

//MARK: - Search Update

extension TransaksiViewController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredTransaksi = transaksiData.filter
            { (transaksi: TransaksiData) -> Bool in
                return (transaksi.idHewan?.idCustomer_Member.namaCustomer.lowercased().contains(searchText.lowercased()) ?? true)
        }
        
        transaksiTable.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

//MARK: - Picker Data Source
extension TransaksiViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hewanData.count
    }
}

//MARK: - Picker Delegate
extension TransaksiViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return hewanData[row].namaHewan
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        hewanValue = hewanData[row].idHewan
    }
}

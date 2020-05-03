//
//  LayananViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 27/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LayananViewController: UIViewController {

    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    @IBOutlet weak var jenisLayananTable: UITableView!
    
    
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var index: IndexPath?
    var dataLayanan: [ProdukLayananData] = []
    var layananManager = ProdukLayananManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initElement()
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 5
        
        jenisLayananTable.dataSource = self
        jenisLayananTable.delegate = self
        layananManager.delegate = self
        layananManager.fetch_all()
    }
    
    @IBAction func btnSave(_ sender: Any)
    {
        
        if btnAdd.currentTitle == "Save"
        {
            if txtNama.text != ""
            {
                layananManager.store_data(nama: txtNama.text!)
            }
        }
    }
    
    @IBAction func btnClear(_ sender: Any)
    {
        initElement()
    }
    
    func initElement()
    {
        txtID.isHidden = true
        txtCreated.isHidden = true
        txtEdited.isHidden = true
        txtDeleted.isHidden = true
        txtNama.text = nil
        btnAdd.setTitle("Save", for: .normal)
        
        if let indexes = index
        {
            jenisLayananTable.deselectRow(at: indexes, animated: false)
        }
        
    }
    
    func deInit()
    {
        txtID.isHidden = false
        txtCreated.isHidden = false
        txtEdited.isHidden = false
        txtDeleted.isHidden = false
        btnAdd.setTitle("Edit", for: .normal)
    }
    
}

//MARK: - Produk Layanan Delegate

extension LayananViewController: ProdukLayananManagerDelegate
{
    
    func didFetch(produkLayanan: ProdukLayanan) {
        
        dataLayanan = []
        
        for layanans in produkLayanan.Data
        {
            dataLayanan.append(layanans)
        }
        
        DispatchQueue.main.async {
            self.jenisLayananTable.reloadData()
        }
    }
    
    func didMessage(title: String, message: String) {
        
        if title == "Success"
        {
            layananManager.fetch_all()
        }
        
        Constant.showAlert(title: title, message: message, sender: self
            , back: false)
    }
    
}


extension LayananViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLayanan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayananCell", for: indexPath)
                
        cell.textLabel?.text = dataLayanan[indexPath.row].namaLayanan
        cell.detailTextLabel?.text = "ID Jenis Layanan : \(dataLayanan[indexPath.row].idLayanan)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            layananManager.delete_data(id: dataLayanan[indexPath.row].idLayanan)
            dataLayanan.remove(at: indexPath.row)
            
            jenisLayananTable.reloadData()
        }
    }
}

extension LayananViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deInit()
        txtID.text = "ID Jenis Layanan : \(dataLayanan[indexPath.row].idLayanan)"
        txtNama.text = dataLayanan[indexPath.row].namaLayanan
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dataLayanan[indexPath.row].created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = dataLayanan[indexPath.row].edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(dataLayanan[indexPath.row].edited_by)"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = dataLayanan[indexPath.row].deleted_at
        {
            temp = dateFormatter2.date(from: date)!
            txtDeleted.text = "deleted at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtDeleted.isHidden = true
        }
        
        index = indexPath
        
    }
    
}

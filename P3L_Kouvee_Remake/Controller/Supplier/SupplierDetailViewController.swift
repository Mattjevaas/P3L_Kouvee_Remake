//
//  SupplierDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SupplierDetailViewController: UIViewController {
    
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtAlamat: UITextField!
    @IBOutlet weak var txtNotelp: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var dataSupplier: SupplierData?
    var supplierManager = SupplierManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if dataSupplier != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        supplierManager.delegate = self
        initField()
    }
    
    func initField()
    {
        if let id = dataSupplier?.idSupplier
        {
            txtID.text = "ID Supplier : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtEmail.text = dataSupplier?.email
        txtNama.text = dataSupplier?.namaSupplier
        txtAlamat.text = dataSupplier?.alamat
        txtNotelp.text = dataSupplier?.noTelp
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dataSupplier?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = dataSupplier?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(dataSupplier?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = dataSupplier?.deleted_at
        {
            temp = dateFormatter2.date(from: date)!
            txtDeleted.text = "deleted at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtDeleted.isHidden = true
        }
    }
    
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        if(txtEmail.text != nil && txtNotelp.text != nil && txtAlamat.text != nil && txtNama.text != nil)
        {
            if btnAdd.currentTitle == "Save"
            {
                supplierManager.store_data(nama: txtNama.text!, alamat: txtAlamat.text!, telp: txtNotelp.text!, email: txtEmail.text!)
            }
            else
            {
                supplierManager.edit_data(nama: txtNama.text!, alamat: txtAlamat.text!, telp: txtNotelp.text!, email: txtEmail.text!,id: dataSupplier!.idSupplier)
            }
        }
    }
}


//MARK: - Supplier Delegate
extension SupplierDetailViewController: SupplierManagerDelegate
{
    func didMessage(title: String, message: String) {
        if title == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
    }
    
    func didFetch(supplier: Supplier)
    {
        if supplier.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

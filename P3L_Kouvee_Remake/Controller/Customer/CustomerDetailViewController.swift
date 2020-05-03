//
//  CustomerDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController {
    
    
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCustomer: UITextField!
    @IBOutlet weak var txtAlamat: UITextField!
    @IBOutlet weak var txtTelp: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var strDate: String?
    var dataForSegueCustomer: CustomerData?
    var customerManager = CustomerManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if dataForSegueCustomer != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        customerManager.delegate = self
        initInputField()
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        if(txtEmail.text != nil && txtTelp.text != nil && txtAlamat.text != nil && txtCustomer.text != nil && strDate != nil)
        {
            if btnAdd.currentTitle == "Save"
            {
                customerManager.store_data(nama: txtCustomer.text!, lahir: strDate!, alamat: txtAlamat.text!, telp: txtTelp.text!, email: txtEmail.text!)
            }
            else
            {
                customerManager.edit_data(nama: txtCustomer.text!, lahir: strDate!, alamat: txtAlamat.text!, telp: txtTelp.text!, email: txtEmail.text!, id: dataForSegueCustomer!.idCustomer_Member)
            }
            
        }
    }
    
    @IBAction func pickerChange(_ sender: Any)
    {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        strDate = dateFormatter.string(from: datePicker.date)
    }
    
    
    func initInputField()
    {
        
        if let id = dataForSegueCustomer?.idCustomer_Member
        {
            txtID.text = "ID Pegawai : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtEmail.text = dataForSegueCustomer?.email
        txtTelp.text = dataForSegueCustomer?.noTelp
        txtAlamat.text = dataForSegueCustomer?.alamat
        txtCustomer.text = dataForSegueCustomer?.namaCustomer
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dataForSegueCustomer?.tglLahir
        {
            strDate = date
            datePicker.date = dateFormatter.date(from: date)!
        }
        else
        {
            strDate = dateFormatter.string(from: datePicker.date)
        }
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dataForSegueCustomer?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = dataForSegueCustomer?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(dataForSegueCustomer?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = dataForSegueCustomer?.deleted_at
        {
            temp = dateFormatter2.date(from: date)!
            txtDeleted.text = "deleted at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtDeleted.isHidden = true
        }
        
    }
    
}

//MARK: - CustomerManagerDelegate

extension CustomerDetailViewController: CustomerManagerDelegate
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
    
    func didFetch(customer: Customer)
    {
        if customer.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

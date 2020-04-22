//
//  HewanDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HewanDetailViewController: UIViewController {


    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtNama: UITextField!
    
    @IBOutlet weak var pickerUkuran: UIPickerView!
    @IBOutlet weak var pickerJenis: UIPickerView!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var pickerCustomer: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    

    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    
    var ukuranManager = UkuranHewanManager()
    var dataUkuran: [UkuranHewanData] = []
    var ukuranValue: Int?
    
    var jenisManager = JenisHewanManager()
    var dataJenis: [JenisHewanData] = []
    var jenisValue: Int?
    
    var customerManager = CustomerManager()
    var dataCustomer: [CustomerData] = []
    var customerValue: Int?
    
    var hewanManager = HewanManager()
    var hewanData: HewanData?
    var strDate: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if hewanData != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        pickerUkuran.dataSource = self
        pickerUkuran.delegate = self
        ukuranManager.delegate = self
        
        pickerJenis.dataSource = self
        pickerJenis.delegate = self
        jenisManager.delegate = self
        
        pickerCustomer.dataSource = self
        pickerCustomer.delegate = self
        customerManager.delegate = self
        
        customerManager.fetch_all()
        ukuranManager.fetch_all()
        jenisManager.fetch_all()
        initData()
    }
    
    func initData()
    {
        if let id = hewanData?.idHewan
        {
            txtID.text = "ID Hewan : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtNama.text = hewanData?.namaHewan
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = hewanData?.tglLahir
        {
            strDate = date
            pickerDate.date = dateFormatter.date(from: date)!
        }
        else
        {
            strDate = dateFormatter.string(from: pickerDate.date)
        }
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = hewanData?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = hewanData?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(hewanData?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = hewanData?.deleted_at
        {
            temp = dateFormatter2.date(from: date)!
            txtDeleted.text = "deleted at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtDeleted.isHidden = true
        }
        
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        
        if txtNama.text != nil, ukuranValue != nil, jenisValue != nil, customerValue != nil, strDate != nil
        {
            if btnAdd.currentTitle == "Save"
            {
                hewanManager.store_data(nama: txtNama.text!, lahir: strDate!, idUkuran: ukuranValue!, idJenis: jenisValue!, idCustomer: customerValue!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func pickerDateChange(_ sender: Any)
    {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        strDate = dateFormatter.string(from: pickerDate.date)
        print(strDate!)
    }
    
}

//
//  ProdukLayananDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 26/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProdukLayananDetailViewController: UIViewController {
    
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtHarga: UITextField!
    @IBOutlet weak var pickerUkuran: UIPickerView!
    @IBOutlet weak var pickerJenis: UIPickerView!
    @IBOutlet weak var pickerLayanan: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var ukuranManager = UkuranHewanManager()
    var dataUkuran: [UkuranHewanData] = []
    var ukuranValue: Int?
    
    var jenisManager = JenisHewanManager()
    var dataJenis: [JenisHewanData] = []
    var jenisValue: Int?
    
    var layananManager = ProdukLayananManager()
    var dataLayanan: [ProdukLayananData] = []
    var layananValue: Int?
    
    var hargaLayananManager = HargaLayananManager()
    var dataHargaLayanan: HargaLayananData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if dataHargaLayanan != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        pickerUkuran.dataSource = self
        pickerUkuran.delegate = self
        ukuranManager.delegate = self
        
        pickerJenis.dataSource = self
        pickerJenis.delegate = self
        jenisManager.delegate = self
        
        pickerLayanan.dataSource = self
        pickerLayanan.delegate = self
        layananManager.delegate = self
        
        layananManager.fetch_all()
        ukuranManager.fetch_all()
        jenisManager.fetch_all()
        hargaLayananManager.delegate = self
        initData()
        
    }
    
    func initData()
    {
        if let id = dataHargaLayanan?.idHargaLayanan
        {
            txtID.text = "ID Service : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtHarga.text = dataHargaLayanan?.hargaLayanan
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dataHargaLayanan?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = dataHargaLayanan?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(dataHargaLayanan?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = dataHargaLayanan?.deleted_at
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
        
        if txtHarga.text != nil, ukuranValue != nil, jenisValue != nil, layananValue != nil
        {
            if btnAdd.currentTitle == "Save"
            {
                hargaLayananManager.store_data(harga: txtHarga.text!, idUkuran: ukuranValue!, idJenis: jenisValue!, idLayanan: layananValue!)
            }
            else
            {
                hargaLayananManager.edit_data(harga: txtHarga.text!, idUkuran: ukuranValue!, idJenis: jenisValue!, idLayanan: layananValue!,id: dataHargaLayanan!.idHargaLayanan)
            }
        }
    }
}

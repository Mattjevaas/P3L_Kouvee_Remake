//
//  UkuranHewanDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UkuranHewanDetailViewController: UIViewController {

    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var ukuranManager = UkuranHewanManager()
    var ukuranData: UkuranHewanData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if ukuranData != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        ukuranManager.delegate = self
        initField()
    }
    
    func initField()
    {
        if let id = ukuranData?.idUkuranHewan
        {
            txtID.text = "ID Ukuran : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtNama.text = ukuranData?.ukuranHewan
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = ukuranData?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = ukuranData?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(ukuranData?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = ukuranData?.deleted_at
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
        if(txtNama.text != nil)
        {
            if btnAdd.currentTitle == "Save"
            {
                ukuranManager.store_data(nama: txtNama.text!)
            }
        }
    }
}

extension UkuranHewanDetailViewController: UkuranHewanManagerDelegate
{
    func didMessageUkuran(title: String, message: String) {
        if title == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
    }
    
    func didFetchUkuran(ukuranhewan: UkuranHewan) {
        
        if ukuranhewan.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

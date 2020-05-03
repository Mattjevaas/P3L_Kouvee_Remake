//
//  ProdukBarangDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 22/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProdukBarangDetailViewController: UIViewController {
    
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtSatuan: UITextField!
    @IBOutlet weak var txtJumlah: UITextField!
    @IBOutlet weak var txtJual: UITextField!
    @IBOutlet weak var txtBeli: UITextField!
    @IBOutlet weak var txtStockMin: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCreated: UILabel!
    @IBOutlet weak var txtEdited: UILabel!
    @IBOutlet weak var txtDeleted: UILabel!
    
    var stat: Int = 0
    var imagesURL: URL? = nil
    
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
    var produkBarangData: ProdukBarangData?
    var produkBarangManager = ProdukBarangManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelect.layer.cornerRadius = btnSelect.frame.size.height / 2
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height / 2
        
        if produkBarangData != nil
        {
            btnAdd.setTitle("Edit", for: .normal)
        }
        
        produkBarangManager.delegate = self
        initField()
        
    }
    
    func initField()
    {
        if let id = produkBarangData?.idProduk
        {
            txtID.text = "ID Barang : \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        txtNama.text = produkBarangData?.namaProduk
        txtSatuan.text = produkBarangData?.satuan
        txtJumlah.text = produkBarangData?.jumlahProduk
        txtJual.text = produkBarangData?.hargaJual
        txtBeli.text = produkBarangData?.hargaBeli
        txtStockMin.text = produkBarangData?.stokMinimal
        
        if produkBarangData?.linkGambar != nil
        {
            imagesURL = URL(string: "\(Constant.urlStorage)/\(produkBarangData?.linkGambar ?? "")")
            
            DispatchQueue.global().async {
                guard let imagesData = try? Data(contentsOf: self.imagesURL!) else { return }
                
                let image = UIImage(data: imagesData)
                DispatchQueue.main.async {
                    self.ItemImage.image = image
                }
            }
        }
        
        var temp: Date
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = produkBarangData?.created_at
        {
            temp = dateFormatter2.date(from: date)!
            txtCreated.text = "created at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtCreated.isHidden = true
        }
        
        if let date = produkBarangData?.edited_at
        {
            temp = dateFormatter2.date(from: date)!
            txtEdited.text = "edited at : \(dateFormatter3.string(from: temp)) | Pegawai ID : \(produkBarangData?.edited_by ?? "-")"
        }
        else
        {
            txtEdited.isHidden = true
        }
            
        if let date = produkBarangData?.deleted_at
        {
            temp = dateFormatter2.date(from: date)!
            txtDeleted.text = "deleted at : \(dateFormatter3.string(from: temp))"
        }
        else
        {
            txtDeleted.isHidden = true
        }
    }
    
    @IBAction func btnSave(_ sender: Any)
    {
        if txtNama.text != nil, txtSatuan.text != nil, txtJumlah.text != nil, txtJual.text != nil, txtBeli.text != nil, txtStockMin.text != nil, stat == 1
        {
            if btnAdd.currentTitle == "Save"
            {
                produkBarangManager.store_data(nama: txtNama.text!, satuan: txtSatuan.text!, jumlahProduk: txtJumlah.text!, hargaJual: txtJual.text!, hargaBeli: txtBeli.text!, stokMinimal: txtStockMin.text!, image: ItemImage.image!)
            }
            else
            {
                produkBarangManager.edit_data(nama: txtNama.text!, satuan: txtSatuan.text!, jumlahProduk: txtJumlah.text!, hargaJual: txtJual.text!, hargaBeli: txtBeli.text!, stokMinimal: txtStockMin.text!, image: ItemImage.image!,id: produkBarangData!.idProduk)
            }
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
}

//MARK: - ProdukBarangDelegate

extension ProdukBarangDetailViewController: ProdukBarangManagerDelegate
{
    func didMessageProdukBarang(title: String, message: String) {
        
        if title == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
    }
    
    func didFetchProdukBarang(produkBarang: ProdukBarang)
    {
        if produkBarang.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK: - ImagePicker

extension ProdukBarangDetailViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        ItemImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        stat = 1
        self.dismiss(animated: true, completion: nil)
    }
}


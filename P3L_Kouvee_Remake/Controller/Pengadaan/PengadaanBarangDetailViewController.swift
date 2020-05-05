//
//  PengadaanBarangDetailViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 29/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PengadaanBarangDetailViewController: UIViewController {
    
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var TglPengadaan: UILabel!
    @IBOutlet weak var Nama: UILabel!
    @IBOutlet weak var Supplier: UILabel!
    @IBOutlet weak var btnDatang: UIButton!
    @IBOutlet weak var btnCetak: UIButton!
    @IBOutlet weak var tableItem: UITableView!
    @IBOutlet weak var pickerProduct: UIPickerView!
    @IBOutlet weak var txtJumlahProduk: UITextField!
    @IBOutlet weak var txtTotalHarga: UILabel!
    @IBOutlet weak var stockMenipis: UILabel!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var txtTotalKeseluruhan: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    
    var menuOut = false
    var total: Int = 0
    var indexPaths: IndexPath? = nil
    var produkBarangManager = ProdukBarangManager()
    var produkBarangData: [ProdukBarangData] = []
    var produkValue: Int = 0
    var produkHarga: String = ""
    
    var pengadaanBarangManager = PengadaanBarangManager()
    var pengadaanBarangData: PengadaanBarangData?
    
    var rincianPengadaanManager =  RincianPengadaanManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rincianPengadaanManager.delegate = self
        produkBarangManager.delegate = self
        produkBarangManager.fetch_all()
        pickerProduct.dataSource = self
        pickerProduct.delegate = self
        
        btnCetak.layer.cornerRadius = btnCetak.frame.size.height / 2
        btnDatang.layer.cornerRadius = btnDatang.frame.size.height / 2
        
        pengadaanBarangManager.delegate = self
        tableItem.dataSource = self
        tableItem.delegate = self
        initData()
    }
    
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        
        if sender.currentTitle == "Add"
        {
            if txtJumlahProduk.text != "0"
            {
                rincianPengadaanManager.store_data(jumlah: Int(txtJumlahProduk.text!)!, idPengadaan: pengadaanBarangData!.idPengadaanBarang, idProduk: produkValue)
                
                total += (Int(txtJumlahProduk.text!)! * Int(produkHarga)!)
                txtTotalKeseluruhan.text = "Total Harga Keseluruhan Rp. \(total)"
            }
        }
        else
        {
            if txtJumlahProduk.text != "0"
            {
                rincianPengadaanManager.edit_data(jumlah: Int(txtJumlahProduk.text!)!, idPengadaan: pengadaanBarangData!.idPengadaanBarang, idProduk: produkValue,id: (pengadaanBarangData?.listProduct[indexPaths!.row].idRincianPengadaan)!)
                
                total -= Int((pengadaanBarangData?.listProduct[indexPaths!.row].jumlahBeli)!)! * Int((pengadaanBarangData?.listProduct[indexPaths!.row].idProduk.hargaBeli)!)!
                total += (Int(txtJumlahProduk.text!)! * Int(produkHarga)!)
                txtTotalKeseluruhan.text = "Total Harga Keseluruhan Rp. \(total)"
                
            }
        }
        
    }
    
    @IBAction func openMenuAdd(_ sender: Any) {
        
        txtJumlahProduk.text = "0"
        pickerProduct.selectRow(0, inComponent: 0, animated: false)
        txtTotalHarga.text = "Total : Rp. 0"
        btnAdd.setTitle("Add", for: .normal)
        
        if let index = indexPaths
        {
            tableItem.deselectRow(at: index, animated: false)
        }
        
        if menuOut == false
        {
            top.constant = -210
            bottom.constant = -210
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
    
    @IBAction func btnConfirm(_ sender: UIButton) {
        if sender.currentTitle == "Belum Cetak"
        {
            pengadaanBarangManager.confirm_cetak(id: pengadaanBarangData!.idPengadaanBarang)
            
            sender.setTitle("Sudah Cetak", for: .normal)
            sender.backgroundColor = UIColor.green
            btnAddItem.isHidden = true
        }
        
        if sender.currentTitle == "Belum Datang" && btnCetak.currentTitle == "Sudah Cetak"
        {
            pengadaanBarangManager.confirm_datang(id: pengadaanBarangData!.idPengadaanBarang)
            
            sender.setTitle("Sudah Datang", for: .normal)
            sender.backgroundColor = UIColor.green
        }
    }
    
    
    
    @IBAction func setJumlah(_ sender: UIButton) {
        
        
        if let value = txtJumlahProduk.text
        {
            var number = Int(value)
            
            if sender.currentTitle == "+"
            {
                number!+=1
                txtJumlahProduk.text = String(number!)
            }
            else
            {
                number!-=1
                txtJumlahProduk.text = String(number!)
            }
            
            txtTotalHarga.text = "Total : Rp. \(Int(txtJumlahProduk.text!)! * Int(produkHarga)!)"
        }
        
        
    }
    
    
    func initData()
    {
        if let id = pengadaanBarangData?.idPengadaanBarang
        {
            txtID.text = "ID Pengadaan : PO - \(id)"
        }
        else
        {
            txtID.isHidden = true
        }
        
        Nama.text = pengadaanBarangData?.namaPengadaan
        Supplier.text = pengadaanBarangData?.idSupplier.namaSupplier
        
        if let tgl = pengadaanBarangData?.tglPengadaan
        {
            TglPengadaan.text = "Tanggal Pengadaan : \(tgl)"
        }
        else
        {
            TglPengadaan.isHidden = true
        }
        
        if pengadaanBarangData?.statusBrgDatang != nil
        {
            if pengadaanBarangData?.statusBrgDatang == "Sudah Datang"
            {
                btnDatang.setTitle("Sudah Datang", for: .normal)
                btnDatang.backgroundColor = UIColor.green
            }
            
        }
        
        if pengadaanBarangData?.statusCetak != nil
        {
            if pengadaanBarangData?.statusCetak == "Sudah Cetak"
            {
                btnCetak.setTitle("Sudah Cetak", for: .normal)
                btnCetak.backgroundColor = UIColor.green
                
                btnAddItem.isHidden = true
            }
        }
        
        total = Int(pengadaanBarangData!.total)!
        txtJumlahProduk.text = "0"
        txtTotalKeseluruhan.text = "Total Harga Keseluruhan Rp. \(total)"
        
    }
    
    
}

//MARK: - Harga Delegate
extension PengadaanBarangDetailViewController: PengadaanBarangManagerDelegate
{
    func didMessagePengadaanBarang(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchPengadaanBarang(pengadaanBarang: PengadaanBarang) {
        if pengadaanBarang.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Table Data Source & Delegate
extension PengadaanBarangDetailViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pengadaanBarangData?.listProduct.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let total = Double((pengadaanBarangData?.listProduct[indexPath.row].jumlahBeli)!)! * Double((pengadaanBarangData?.listProduct[indexPath.row].idProduk.hargaBeli)!)!
        
        cell.textLabel?.text = "\(pengadaanBarangData?.listProduct[indexPath.row].jumlahBeli ?? "") - \(pengadaanBarangData?.listProduct[indexPath.row].idProduk.namaProduk ?? "")"
        cell.detailTextLabel?.text = "Harga Satuan : Rp.\(pengadaanBarangData?.listProduct[indexPath.row].idProduk.hargaBeli ?? "") | Harga Total : Rp.\(total)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if btnCetak.currentTitle == "Belum Cetak"
        {
            return true
        }
        
        return false
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            total -= Int((pengadaanBarangData?.listProduct[indexPath.row].idProduk.hargaBeli)!)! * Int((pengadaanBarangData?.listProduct[indexPath.row].jumlahBeli)!)!
            txtTotalKeseluruhan.text = "Total Harga Keseluruhan Rp. \(total)"
            
            rincianPengadaanManager.delete_data(id: (pengadaanBarangData?.listProduct[indexPath.row].idRincianPengadaan)!)
            pengadaanBarangData?.listProduct.remove(at: indexPath.row)
            tableView.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btnCetak.currentTitle == "Belum Cetak"
        {
            indexPaths = indexPath
            
            btnAdd.setTitle("Edit", for: .normal)
            top.constant = -210
            bottom.constant = -210
            menuOut = true
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            txtJumlahProduk.text = pengadaanBarangData?.listProduct[indexPath.row].jumlahBeli
            
            let id = pengadaanBarangData!.listProduct[indexPath.row].idProduk.idProduk
            var index = 0
            
            for item in produkBarangData
            {
                if item.idProduk == id
                {
                    break
                }
                
                index += 1
            }
            
            pickerProduct.selectRow(index, inComponent: 0, animated: false)
            produkHarga = produkBarangData[index].hargaBeli
            txtTotalHarga.text = "Total : Rp. \(Int(txtJumlahProduk.text!)! * Int((pengadaanBarangData?.listProduct[indexPath.row].idProduk.hargaBeli)!)!)"
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}



//MARK: - Produk Delegate

extension PengadaanBarangDetailViewController: ProdukBarangManagerDelegate
{
    func didFetchProdukBarang(produkBarang: ProdukBarang) {
        
        produkBarangData = []
        
        for barangs in produkBarang.Data
        {
            produkBarangData.append(barangs)
        }
        
        DispatchQueue.main.async {
            self.pickerProduct.reloadAllComponents()
        }
        
        
        produkValue = produkBarangData[0].idProduk
        produkHarga = produkBarangData[0].hargaBeli
        
        
        if Int(produkBarangData[0].jumlahProduk)! <= Int(produkBarangData[0].stokMinimal)!
        {
            stockMenipis.isHidden = false
        }
        else
        {
            stockMenipis.isHidden = true
        }
    }
    
    func didMessageProdukBarang(title: String, message: String) {
        
        Constant.showAlert(title: title, message: message, sender: self, back: false)
        
    }
    
    
}

//MARK: - Picker Data Source

extension PengadaanBarangDetailViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return produkBarangData.count
    }

}

//MARK: - Picker Delegate
extension PengadaanBarangDetailViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return produkBarangData[row].namaProduk
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        produkValue = produkBarangData[row].idProduk
        produkHarga = produkBarangData[row].hargaBeli
        
        if Int(produkBarangData[row].jumlahProduk)! <= Int(produkBarangData[row].stokMinimal)!
        {
            stockMenipis.isHidden = false
        }
        else
        {
            stockMenipis.isHidden = true
        }
        
    }
    
}

//MARK: - Text Field Delegate
extension PengadaanBarangDetailViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let values = textField.text
        {
            let numbers = Int(values)
            let calc = numbers! * Int(produkHarga)!
            
            txtTotalHarga.text = "Total : Rp. \(String(calc))"
        }
        
    }
}

//MARK: - Rincian Delegate
extension PengadaanBarangDetailViewController: RincianPengadaanManagerDelegate
{
    func didFetchRincianPengadaan(rincianPengadaan: RincianPengadaan) {
        return
    }
    
    func didMessageRincianPengadaan(title: String, message: String) {
        if title == "Success"
        {
            
            top.constant = 0
            bottom.constant = 0
            menuOut = false
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
        }
        
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    
}


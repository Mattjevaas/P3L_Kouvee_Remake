//
//  RincianProdukViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 07/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RincianProdukViewController: UIViewController {

    @IBOutlet weak var txtId: UILabel!
    @IBOutlet weak var txtTgl: UILabel!
    @IBOutlet weak var txtNama: UILabel!
    @IBOutlet weak var txtHewan: UILabel!
    @IBOutlet weak var txtPegawai: UILabel!
    @IBOutlet weak var btnLunas: UIButton!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var produkTable: UITableView!
    @IBOutlet weak var txtTotaPembayaran: UILabel!
    @IBOutlet weak var pickerProduk: UIPickerView!
    @IBOutlet weak var txtJumlahProduk: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var txtHarga: UILabel!
    
    
    var menuOut = false
    
    var indexz = 0
    var produkValue: Int = 0
    var produkData: [ProdukBarangData] = []
    var produkManager = ProdukBarangManager()
    var transaksiData: TransaksiData?
    
    var idRincian = -1
    var rincianManager =  RincianPembelianManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnLunas.layer.cornerRadius = btnLunas.frame.size.height / 5
        produkTable.delegate = self
        produkTable.dataSource = self
        produkManager.delegate = self
        pickerProduk.delegate = self
        pickerProduk.dataSource = self
        rincianManager.delegate = self
        
        produkManager.fetch_all()
        initElement()
    }
    
    @IBAction func btnAddItem(_ sender: Any)
    {
        
        pickerProduk.selectRow(0, inComponent: 0, animated: false)
        btnSave.setTitle("Save", for: .normal)
        txtJumlahProduk.text = "0"
        txtHarga.text = "Harga : Rp. 0"
        
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
    
    
    @IBAction func btnCalc(_ sender: UIButton)
    {
        var value = Int(txtJumlahProduk.text!)!
        
        if sender.currentTitle == "+"
        {
            value+=1
            txtJumlahProduk.text = String(value)
        }
        else
        {
            value-=1
            txtJumlahProduk.text = String(value)
        }
        
        let total = value * Int(produkData[indexz].hargaJual)!
        txtHarga.text = "Harga : Rp. \(total)"
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        if sender.currentTitle == "Save"
        {
            if txtJumlahProduk.text != ""
            {
                rincianManager.store_data(jumlahBeli: Int(txtJumlahProduk.text!)!, jenisPembelian: "Produk", idProduk: produkValue, idHargaLayanan: nil, idTransaksiPembayaran: transaksiData!.idTransaksiPembayaran)
            }
        }
        else
        {
            if txtJumlahProduk.text != ""
            {
                rincianManager.edit_data(jumlahBeli: Int(txtJumlahProduk.text!)!, jenisPembelian: "Produk", idProduk: produkValue, idHargaLayanan: nil, idTransaksiPembayaran: transaksiData!.idTransaksiPembayaran, id: idRincian)
            }

        }
    }
    
    func initElement()
    {
        txtId.text = "ID Transaksi : PR - \(transaksiData?.idTransaksiPembayaran ?? 0)"
        txtTgl.text = "Tanggal Transaksi : \(transaksiData?.tglTransaksi ?? "")"
        
        txtNama.text = transaksiData?.idHewan?.idCustomer_Member.namaCustomer
        txtHewan.text = transaksiData?.idHewan?.namaHewan
        txtPegawai.text = transaksiData?.idPegawai
        
        if transaksiData?.statusLunas == "Sudah Lunas"
        {
            btnLunas.setTitle("Sudah Lunas", for: .normal)
            btnLunas.backgroundColor = UIColor.green
            
            btnAddItem.isHidden = true
        }
        
        txtTotaPembayaran.text = "Total Pembayaran : Rp. \(transaksiData?.totalBayar ?? "0")"
        
    }

}


//MARK: - Table Delegate & Data Source
extension RincianProdukViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return transaksiData?.listProduct.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RincianItemCell", for: indexPath)
        
        let total = Int((transaksiData?.listProduct[indexPath.row].jumlahBeli)!)! * Int((transaksiData?.listProduct[indexPath.row].idProduk!.hargaJual)!)!
        
        cell.textLabel?.text = "\(transaksiData?.listProduct[indexPath.row].jumlahBeli ?? "") \(transaksiData?.listProduct[indexPath.row].idProduk?.namaProduk ?? "")"
        
        cell.detailTextLabel?.text = "Harga : Rp. \(transaksiData?.listProduct[indexPath.row].idProduk?.hargaJual ?? "") | Total : Rp. \(total)"
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            rincianManager.delete_data(id: (transaksiData?.listProduct[indexPath.row].idRincianPembelian)!)
            transaksiData?.listProduct.remove(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btnLunas.currentTitle == "Belum Lunas"
        {
            
            btnSave.setTitle("Edit", for: .normal)
            
            top.constant = -290
            bottom.constant = -290
            
            menuOut = true
            
             UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            var index = 0
            
            for data in produkData
            {
                if data.idProduk == transaksiData?.listProduct[indexPath.row].idProduk?.idProduk
                {
                    break
                }
                
                index+=1
            }
            
            indexz = index
            let hargaz = Int(transaksiData!.listProduct[indexPath.row].idProduk!.hargaJual)! * Int(transaksiData!.listProduct[indexPath.row].jumlahBeli)!
            
            produkValue = produkData[index].idProduk
            pickerProduk.selectRow(index, inComponent: 0, animated: false)
            txtJumlahProduk.text = transaksiData?.listProduct[indexPath.row].jumlahBeli
            txtHarga.text = "Harga : Rp. \(hargaz)"
            idRincian = Int(transaksiData!.listProduct[indexPath.row].idRincianPembelian)
            
        }
        
    }
}

//MARK: - Picker Data Source
extension RincianProdukViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return produkData.count
    }
}

//MARK: - Picker Delegate
extension RincianProdukViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(produkData[row].namaProduk)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        produkValue = produkData[row].idProduk
        indexz = row
        txtJumlahProduk.text = "0"
        txtHarga.text = "Harga : Rp. 0"
    }
}

//MARK: - Produk Delegate
extension RincianProdukViewController: ProdukBarangManagerDelegate
{
    func didFetchProdukBarang(produkBarang: ProdukBarang) {
        
        produkData = []
        
        for produkz in produkBarang.Data
        {
            produkData.append(produkz)
        }
        
        produkValue = produkData[0].idProduk
        txtHarga.text = "Harga : Rp. \(produkData[0].hargaJual)"
        
        DispatchQueue.main.async {
            self.pickerProduk.reloadAllComponents()
        }
    }
    
    func didMessageProdukBarang(title: String, message: String) {
        
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
}

//MARK: - Produk Delegate
extension RincianProdukViewController: RincianPembelianManagerDelegate
{
    
    func didFetchRincianPembelian(transaksi: RincianPembelian) {
        return
    }
    
    func didMessageRincianPembelian(title: String, message: String) {
        
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

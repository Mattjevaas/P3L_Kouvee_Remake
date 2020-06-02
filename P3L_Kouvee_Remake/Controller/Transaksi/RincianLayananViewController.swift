//
//  RincianLayananViewController.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 06/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RincianLayananViewController: UIViewController {

    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtTanggal: UILabel!
    @IBOutlet weak var txtNama: UILabel!
    @IBOutlet weak var txtHewan: UILabel!
    @IBOutlet weak var btnSelesai: UIButton!
    @IBOutlet weak var btnLunas: UIButton!
    @IBOutlet weak var tableRincian: UITableView!
    @IBOutlet weak var txtCS: UILabel!
    @IBOutlet weak var btnAddLayanan: UIButton!
    @IBOutlet weak var txtTotalPembayaran: UILabel!
    @IBOutlet weak var pickerHargaLayanan: UIPickerView!
    @IBOutlet weak var txtHarga: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    var menuOut = false
    var transaksiData: TransaksiData?
    var rincianManager = RincianPembelianManager()
    var transaksiManager = TransaksiManager()
    
    var idRincian: Int = -1
    var layananValue: Int = 0
    var layananData: [HargaLayananData] = []
    var layananManager = HargaLayananManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnLunas.layer.cornerRadius = btnLunas.frame.size.height / 5
        btnSelesai.layer.cornerRadius = btnSelesai.frame.size.height / 5
        
        tableRincian.delegate = self
        tableRincian.dataSource = self
        pickerHargaLayanan.delegate = self
        pickerHargaLayanan.dataSource = self
        
        rincianManager.delegate = self
        layananManager.delegate = self
        
        layananManager.fetch_all()
        initElement()
        
    }
    
    @IBAction func btnAddLayanan(_ sender: Any) {
        
        btnSave.setTitle("Save", for: .normal)
        pickerHargaLayanan.selectRow(0, inComponent: 0, animated: false)
        txtHarga.text = "Harga : Rp. \(layananData[0].hargaLayanan)"
        
        if menuOut == false
        {
            top.constant = -270
            bottom.constant = -270
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
    
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        if sender.currentTitle == "Save"
        {
            rincianManager.store_data(jumlahBeli: 1, jenisPembelian: "Layanan", idProduk: nil, idHargaLayanan: layananValue, idTransaksiPembayaran: (transaksiData?.idTransaksiPembayaran)!)
        }
        else
        {
            rincianManager.edit_data(jumlahBeli: 1, jenisPembelian: "Layanan", idProduk: nil, idHargaLayanan: layananValue, idTransaksiPembayaran: (transaksiData?.idTransaksiPembayaran)!, id: idRincian)
        }
    }
    
    @IBAction func btnSelesai(_ sender: UIButton) {
        
        if sender.currentTitle == "Belum Selesai"
        {
            
            let idLayanan = "LY-\(transaksiData?.tglTransaksi ?? "")-\(transaksiData?.idTransaksiPembayaran ?? -1)"
            transaksiManager.confirm_selesai(id: transaksiData!.idTransaksiPembayaran)
            transaksiManager.sendSms(number: (transaksiData?.idHewan?.idCustomer_Member.noTelp)!, namaPelanggan: (transaksiData?.idHewan?.idCustomer_Member.namaCustomer)!, layanan: idLayanan, namaHewan: (transaksiData?.idHewan!.namaHewan)!)
            
            sender.setTitle("Sudah Selesai", for: .normal)
            sender.backgroundColor = UIColor.green
            btnAddLayanan.isHidden = true
        }
        
    }
    
    
    func initElement()
    {
        txtID.text = "ID Transaksi : LY - \(transaksiData?.idTransaksiPembayaran ?? 0)"
        
        txtTanggal.text = "Tanggal Transaksi: \(transaksiData?.tglTransaksi ?? "")"
        
        txtNama.text = transaksiData?.idHewan?.idCustomer_Member.namaCustomer
        
        txtHewan.text = "\(transaksiData?.idHewan?.namaHewan ?? "") - \(transaksiData?.idHewan?.idJenisHewan.jenisHewan ?? "")"
        
        txtCS.text = transaksiData?.idPegawai
        
        if transaksiData?.statusSelesai != nil
        {
            btnSelesai.setTitle("Sudah Selesai", for: .normal)
            btnSelesai.backgroundColor = UIColor.green
            btnAddLayanan.isHidden = true
        }
        
        if transaksiData?.statusLunas == "Sudah Lunas"
        {
            btnLunas.setTitle("Sudah Lunas", for: .normal)
            btnLunas.backgroundColor = UIColor.green
            btnAddLayanan.isHidden = true
        }
        
        txtTotalPembayaran.text = "Total Pembayaran : Rp. \(transaksiData?.totalBayar ?? "0")"
    }
    
    
}

//MARK: - Table Data Source & Delegate
extension RincianLayananViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaksiData?.listProduct.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RincianLayananCell", for: indexPath)
        
        cell.textLabel?.text = "\(transaksiData?.listProduct[indexPath.row].idHargaLayanan?.idLayanan.namaLayanan ?? "") \(transaksiData?.listProduct[indexPath.row].idHargaLayanan?.idJenisHewan.jenisHewan ?? "") \(transaksiData?.listProduct[indexPath.row].idHargaLayanan?.idUkuranHewan.ukuranHewan ?? "")"
        
        cell.detailTextLabel?.text = "Harga : Rp. \(transaksiData?.listProduct[indexPath.row].idHargaLayanan?.hargaLayanan ?? "")"
        
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
        
        if btnSelesai.currentTitle != "Sudah Selesai"
        {
            btnSave.setTitle("Edit", for: .normal)
            top.constant = -270
            bottom.constant = -270
            menuOut = true
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}){ (animationComplete) in print("Animation Complete") }
            
            var index = 0
            
            for data in layananData
            {
                if data.idHargaLayanan == transaksiData?.listProduct[indexPath.row].idHargaLayanan?.idHargaLayanan
                {
                    break
                }
                
                index+=1
            }
            
            idRincian = transaksiData!.listProduct[indexPath.row].idRincianPembelian
            pickerHargaLayanan.selectRow(index, inComponent: 0, animated: false)
            txtHarga.text = "Harga : Rp. \(layananData[index].hargaLayanan)"
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - Picker Data Source
extension RincianLayananViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return layananData.count
    }
}

//MARK: - Picker Delegate
extension RincianLayananViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(layananData[row].idLayanan.namaLayanan) \(layananData[row].idJenisHewan.jenisHewan) \(layananData[row].idUkuranHewan.ukuranHewan)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        layananValue = layananData[row].idHargaLayanan
        txtHarga.text = "Harga : Rp. \(layananData[row].hargaLayanan)"
    }
}

//MARK: - Harga Layanan Delegate
extension RincianLayananViewController: HargaLayananManagerDelegate
{
    func didFetchHargaLayanan(hargalayanan: HargaLayanan) {
        
        layananData = []
        
        for layanans in hargalayanan.Data
        {
            layananData.append(layanans)
        }
        
        layananValue = layananData[0].idHargaLayanan
        txtHarga.text = "Harga : Rp. \(layananData[0].hargaLayanan)"
        
        DispatchQueue.main.async {
            self.pickerHargaLayanan.reloadAllComponents()
        }
        
    }
    
    func didMessageHargaLayanan(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
}

//MARK: - Rincian Pembelian Delegate
extension RincianLayananViewController: RincianPembelianManagerDelegate
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

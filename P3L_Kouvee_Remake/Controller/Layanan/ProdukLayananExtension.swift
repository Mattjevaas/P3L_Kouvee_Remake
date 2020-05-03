//
//  ProdukLayananExtension.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 27/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

//MARK: - Layanan Delegate
extension ProdukLayananDetailViewController: ProdukLayananManagerDelegate
{
    func didMessage(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetch(produkLayanan: ProdukLayanan) {
        dataLayanan = []
        
        var k = 0
        var positionLayanan = -1
        
        for layanan in produkLayanan.Data
        {
            if layanan.idLayanan == dataHargaLayanan?.idLayanan.idLayanan
            {
                positionLayanan = k
            }
            
            dataLayanan.append(layanan)
            k+=1
        }
        
        if positionLayanan == -1
        {
            positionLayanan = 0
        }
        
        DispatchQueue.main.async
        {
            self.pickerLayanan.reloadAllComponents()
            self.pickerLayanan.selectRow(positionLayanan, inComponent: 0, animated: false)
        }
        
        layananValue = dataLayanan[positionLayanan].idLayanan
    }
    
}

//MARK: - Ukuran Delegate
extension ProdukLayananDetailViewController: UkuranHewanManagerDelegate
{
    func didMessageUkuran(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchUkuran(ukuranhewan: UkuranHewan)
    {
        dataUkuran = []
        
        var j = 0
        var positionUkuran = -1
        
        for ukuran in ukuranhewan.Data
        {
            if ukuran.idUkuranHewan == dataHargaLayanan?.idUkuranHewan.idUkuranHewan
            {
                positionUkuran = j
            }
            
            dataUkuran.append(ukuran)
            j+=1
        }
        
        if positionUkuran == -1
        {
            positionUkuran = 0
        }
        
        DispatchQueue.main.async
        {
            self.pickerUkuran.reloadAllComponents()
            self.pickerUkuran.selectRow(positionUkuran, inComponent: 0, animated: false)
        }
        
        ukuranValue = dataUkuran[positionUkuran].idUkuranHewan
    }
    
}

//MARK: - Jenis Delegate
extension ProdukLayananDetailViewController: JenisHewanManagerDelegate
{
    func didMessageJenis(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchJenis(jenishewan: JenisHewan)
    {
        dataJenis = []
        var i = 0
        var positionJenis = -1
        
        for jenis in jenishewan.Data
        {
            if jenis.idJenisHewan == dataHargaLayanan?.idJenisHewan.idJenisHewan
            {
                positionJenis = i
            }
            
            dataJenis.append(jenis)
            i += 1
        }
        
        if positionJenis == -1
        {
            positionJenis = 0
        }
        
        DispatchQueue.main.async
        {
            self.pickerJenis.reloadAllComponents()
            self.pickerJenis.selectRow(positionJenis, inComponent: 0, animated: false)
        }
        
        jenisValue = dataJenis[positionJenis].idJenisHewan
    }

}

//MARK: - Picker Data Source
extension ProdukLayananDetailViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView.tag
        {
            case 0: return dataUkuran.count
            case 1: return dataJenis.count
            case 2: return dataLayanan.count
            default: return 0
        }
    }
    
}

//MARK: - Picker Delegate
extension ProdukLayananDetailViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag
        {
            case 0: return dataUkuran[row].ukuranHewan
            case 1: return dataJenis[row].jenisHewan
            case 2: return dataLayanan[row].namaLayanan
            default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag
        {
            case 0: ukuranValue = dataUkuran[row].idUkuranHewan
            case 1: jenisValue = dataJenis[row].idJenisHewan
            case 2: layananValue = dataLayanan[row].idLayanan
            default: return
        }
    }
}

//MARK: Harga Delegate

extension ProdukLayananDetailViewController: HargaLayananManagerDelegate
{
    func didMessageHargaLayanan(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetchHargaLayanan(hargalayanan: HargaLayanan) {
        if hargalayanan.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


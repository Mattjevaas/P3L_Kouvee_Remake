//
//  HewanDetailExtension.swift
//  P3L_Kouvee_Remake
//
//  Created by Admin on 21/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

//MARK: - Hewan Delegate
extension HewanDetailViewController: HewanManagerDelegate
{
    func didMessageHewan(title: String, message: String) {
        if title == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Constant.showAlert(title: title, message: message, sender: self, back: false)
        }
    }
    
    func didFetchHewan(hewan: Hewan) {
        
        if hewan.Status == "Success"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Customer Delegate
extension HewanDetailViewController: CustomerManagerDelegate
{
    func didMessage(title: String, message: String) {
        Constant.showAlert(title: title, message: message, sender: self, back: false)
    }
    
    func didFetch(customer: Customer)
    {
        dataCustomer = []
    
        var k = 0
        var positionCustomer = -1
        
        for customer in customer.Data
        {
            if customer.idCustomer_Member == hewanData?.idCustomer_Member.idCustomer_Member
            {
                positionCustomer = k
            }
            
            dataCustomer.append(customer)
            k+=1
        }
        
        if positionCustomer == -1
        {
            positionCustomer = 0
        }
        
        DispatchQueue.main.async
        {
            self.pickerCustomer.reloadAllComponents()
            self.pickerCustomer.selectRow(positionCustomer, inComponent: 0, animated: false)
        }
        
        customerValue = dataCustomer[positionCustomer].idCustomer_Member
    }
}

//MARK: - Ukuran Delegate
extension HewanDetailViewController: UkuranHewanManagerDelegate
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
            if ukuran.idUkuranHewan == hewanData?.idUkuranHewan.idUkuranHewan
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
extension HewanDetailViewController: JenisHewanManagerDelegate
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
            if jenis.idJenisHewan == hewanData?.idJenisHewan.idJenisHewan
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
extension HewanDetailViewController: UIPickerViewDataSource
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
            case 2: return dataCustomer.count
            default: return 0
        }
    }
    
}

//MARK: - Picker Delegate
extension HewanDetailViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag
        {
            case 0: return dataUkuran[row].ukuranHewan
            case 1: return dataJenis[row].jenisHewan
            case 2: return dataCustomer[row].namaCustomer
            default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag
        {
            case 0: ukuranValue = dataUkuran[row].idUkuranHewan
            case 1: jenisValue = dataJenis[row].idJenisHewan
            case 2: customerValue = dataCustomer[row].idCustomer_Member
            default: return
        }
    }
}


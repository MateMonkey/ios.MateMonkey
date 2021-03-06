//
//  UpdateStockViewController.swift
//  MateMonkey
//
//  Created by Peter on 15.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class UpdateStockViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var valuePickerView: UIPickerView!
    
    // MARK: - Variables
    
    var dealerId: Int?
    
    var pickerData = [String]()
    
    var selected: selectedTextField = .product
    var internStatus = MMStockStatus.unknown
    var internQuantity = MMStockQuantity.piece
    var internProduct = String()
    
    var statusData = [MMStockStatus(rawValue: 0)!.getLocalizedStatus(), MMStockStatus(rawValue: 1)!.getLocalizedStatus(), MMStockStatus(rawValue: 2)!.getLocalizedStatus(), MMStockStatus(rawValue: 3)!.getLocalizedStatus(), MMStockStatus(rawValue: 4)!.getLocalizedStatus()]
    var quantityData = [MMStockQuantity(rawValue: 0)!.getLocalizedQuantity(), MMStockQuantity(rawValue: 1)!.getLocalizedQuantity(), MMStockQuantity(rawValue: 2)!.getLocalizedQuantity()]
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.view.tintColor = UIColor.monkeyGreenDark()
        
        pickerData = mapDictToArray(GlobalValues.productDict)
        
        self.valuePickerView.delegate = self
        self.valuePickerView.dataSource = self
        
        productTextField.delegate = self
        statusTextField.delegate = self
        priceTextField.delegate = self
        quantityTextField.delegate = self
        
        print(statusData)
        
        populateDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapDictToArray(_ dict: [Int:String]) -> [String] {
        var array = [String]()
        for i in 1...dict.count {
            array.append(dict[i]!)
        }
        return array
    }

    // MARK: - Navigation
     
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // check for missing values. ("All values except product are optional")
        
        guard !internProduct.isEmpty else {
            showMissingProductAlert()
            return
        }
        
        guard dealerId != nil else {
            return
        }
        
        var productId = 0
        for (id, product) in GlobalValues.productDict {
            if product == internProduct {
                productId = id
                break
            }
        }

        var price: Float = -1
        if priceTextField.text != nil {
            let floatPrice = priceTextField.text!.floatConverter
            if floatPrice != 0 {
                price = floatPrice * 100
            }
        }
        
        // Make sure the price is not too high (to prevent nasty conversion errors that are fatal)
        guard price < 1000000 else {
            showHighPriceAlert()
            return
        }
        
        MMJSONSender().addStockEntryForDealer(dealerId!, productId: productId, status: String(describing: internStatus), quantity: String(describing: internQuantity), price: Int(price))
        
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Functions
    
    func showMissingProductAlert() {
        let alert: UIAlertController = UIAlertController(title: VisibleStrings.missingProductAlertTitle, message: VisibleStrings.missingProductAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: VisibleStrings.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHighPriceAlert() {
        let alert: UIAlertController = UIAlertController(title: VisibleStrings.highPriceAlertTitle, message: VisibleStrings.highPriceAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: VisibleStrings.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func populateDefaults() {
        statusTextField.text = statusData[4]
        quantityTextField.text = quantityData[1]
    }
    
    // MARK: - Enums
    
    enum selectedTextField {
        case status, product, quantity, price
    }
}
extension UpdateStockViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selected {
        case .product:
            productTextField.text = pickerData[row]
            internProduct = pickerData[row]
            print("internProduct: \(internProduct)")
            break
        case .status:
            statusTextField.text = pickerData[row]
            internStatus = MMStockStatus(rawValue: row)!
            print("internStatus: \(internStatus)")
            break
        case .quantity:
            quantityTextField.text = pickerData[row]
            internQuantity = MMStockQuantity(rawValue: row)!
            print("internQuantity: \(internQuantity)")
            break
        default:
            break
        }
    }
}

extension UpdateStockViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

extension UpdateStockViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == productTextField {
            self.priceTextField.resignFirstResponder()
            self.pickerData = mapDictToArray(GlobalValues.productDict)
            selected = .product
            self.valuePickerView.reloadAllComponents()
            return false
        } else if textField == statusTextField {
            self.priceTextField.resignFirstResponder()
            self.pickerData = statusData
            selected = .status
            self.valuePickerView.reloadAllComponents()
            return false
        } else if textField == quantityTextField {
            self.priceTextField.resignFirstResponder()
            self.pickerData = quantityData
            selected = .quantity
            self.valuePickerView.reloadAllComponents()
            return false
        } else if textField == priceTextField {
            selected = .price
            return true
        } else {
            return true
        }
    }
}

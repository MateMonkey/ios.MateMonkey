//
//  EditDealerViewController.swift
//  MateMonkey
//
//  Created by Peter on 07.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class EditDealerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var dealerNameField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var streetNumberField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    // MARK: - Variables
    
    public var dealerToEdit: MMDealer?
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up data source and delegate for the picker view
        typePicker.dataSource = self
        typePicker.delegate = self
        
        // Assign delegates to all text fields (to make the keyboard disappear on OK)
        dealerNameField.delegate = self
        streetField.delegate = self
        streetNumberField.delegate = self
        zipField.delegate = self
        cityField.delegate = self
        countryField.delegate = self
        phoneNumberField.delegate = self
        emailAddressField.delegate = self
        websiteField.delegate = self
        
        populateFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: check the entries if they exist if they are required and if they are valid
        // TODO: send to a parser/sender class
        // go back to previous view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Mark: - Functions
    
    func populateFields() {
        if let dealer = dealerToEdit {
            dealerNameField.text = dealer.name
            streetField.text = dealer.address.street
            streetNumberField.text = dealer.address.number
            zipField.text = dealer.address.postal
            cityField.text = dealer.address.city
            countryField.text = dealer.address.country
            
            phoneNumberField.text = dealer.address.phone
            emailAddressField.text = dealer.address.email
            websiteField.text = dealer.address.web
            
            let typeInt = dealer.type.rawValue
            
            typePicker.selectRow(typeInt, inComponent: 0, animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditDealerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // we only need one component
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
}

extension EditDealerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let type = MMDealerType(rawValue: row)!
        return String(describing: type).capitalized
    }
}

extension EditDealerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

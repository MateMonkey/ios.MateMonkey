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
    @IBOutlet weak var notesField: UITextField!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    // MARK: - Variables
    
    public var dealerToEdit: MMDealer?
    
    // MARK: - Constants
    
    public let JSONsender = MMJSONSender()
    
    // MARK: - Enums
    
    private enum missingFieldError {
        case name, street, country, city, postal
    }
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.view.tintColor = UIColor.monkeyGreenDark()
        
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
        // check the required entries if they exist if they are required and if they are valid
        guard !emptyRequiredField() else { return }
        guard let dealer = dealerToEdit else {
            let name = dealerNameField.text!
            let notes = notesField.text!
            let type = MMDealerType(rawValue: typePicker.selectedRow(inComponent: 0))!
            
            let street = streetField.text!
            let number = streetNumberField.text!
            let postal = zipField.text!
            let city = cityField.text!
            let country = countryField.text!
            
            let phone = phoneNumberField.text!
            let email = emailAddressField.text!
            let web = websiteField.text!
            
            let address = MMAddress(street: street, country: country, city: city, postal: postal, lat: 0, lon: 0, number: number, web: web, email: email, phone: phone)
            
            MMJSONSender().addDealer(name: name, type: type, address: address, optionalNote: notes)
            
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        var changesToMake = [String: Any]()
        
        if dealerNameField.text! != dealer.name {
            changesToMake["name"] = dealerNameField.text!
        }
        if notesField.text != dealer.note {
            changesToMake["note"] = notesField.text!
        }
        if let updatedType = getTypeUpdateIfDifferent() {
            changesToMake["type"] = updatedType
        }
        
        let addressChanges = getChangedAddressDict()
        if !addressChanges.isEmpty {
            changesToMake["address"] = addressChanges
        }

        // send to a parser/sender class
        if !changesToMake.isEmpty {
            JSONsender.updateDealer(dealer, updatedData: changesToMake)
        }
        
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
            
            notesField.text = dealer.note
            
            let typeInt = dealer.type.rawValue
            
            typePicker.selectRow(typeInt, inComponent: 0, animated: false)
        } else {
            self.title = VisibleStrings.addDealerTitle
            let cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    func emptyRequiredField() -> Bool {
        if (dealerNameField.text?.isEmpty)! {
            missingFieldNotification(missingFieldError.name)
            return true
        }
        if (streetField.text?.isEmpty)! {
            missingFieldNotification(missingFieldError.street)
            return true
        }
        if (zipField.text?.isEmpty)! {
            missingFieldNotification(missingFieldError.postal)
            return true
        }
        if (cityField.text?.isEmpty)! {
            missingFieldNotification(missingFieldError.city)
            return true
        }
        if (countryField.text?.isEmpty)! {
            missingFieldNotification(missingFieldError.country)
            return true
        }
        
        return false
    }
    
    private func missingFieldNotification(_ field: missingFieldError) {
        // Show a notification telling the user what is missing.
        var missingField: String
        switch field {
        case .name:
            missingField = VisibleStrings.missingName
        case .street:
            missingField = VisibleStrings.missingStreet
        case .postal:
            missingField = VisibleStrings.missingPostal
        case .city:
            missingField = VisibleStrings.missingCity
        case .country:
            missingField = VisibleStrings.missingCountry
        }
        
        let messageString = VisibleStrings.missingFieldAlertMessage + missingField
        let missingFieldAlert = UIAlertController(title: VisibleStrings.missingFieldAlertTitle, message: messageString, preferredStyle: .alert)
        missingFieldAlert.addAction(UIAlertAction(title: VisibleStrings.ok, style: .default, handler: nil))
        
        present(missingFieldAlert, animated: true, completion: nil)
    }
    
    func getChangedAddressDict() -> [String: Any] {
        var addressChanges = [String: Any]()
        
        if streetField.text! != dealerToEdit?.address.street {
            addressChanges["street"] = streetField.text!
        }
        if streetNumberField.text != dealerToEdit?.address.number {
            addressChanges["number"] = streetNumberField.text!
        }
        if zipField.text != dealerToEdit?.address.postal {
            addressChanges["postal"] = zipField.text!
        }
        if cityField.text != dealerToEdit?.address.city {
            addressChanges["city"] = cityField.text!
        }
        if countryField.text != dealerToEdit?.address.country {
            addressChanges["country"] = countryField.text!
        }
        if phoneNumberField.text != dealerToEdit?.address.phone {
            addressChanges["phone"] = phoneNumberField.text!
        }
        if emailAddressField.text != dealerToEdit?.address.email {
            addressChanges["email"] = emailAddressField.text!
        }
        if websiteField.text != dealerToEdit?.address.web {
            addressChanges["web"] = websiteField.text!
        }
        
        return addressChanges
    }
    
    func getTypeUpdateIfDifferent() -> String? {
        let typeInt = typePicker.selectedRow(inComponent: 0)
        
        let type = MMDealerType(rawValue: typeInt)!
        if dealerToEdit?.type != type {
            return String(describing: type)
        } else {
            return nil
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
    
    func cancelButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

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

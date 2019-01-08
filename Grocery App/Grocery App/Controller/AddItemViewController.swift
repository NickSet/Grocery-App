//
//  AddItemViewController.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/18/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController {
    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var buttonsArray: [UIButton]!
    @IBOutlet var addItemButton: UIButton!
    @IBOutlet var addItemViewBottomConstraint: NSLayoutConstraint!
    
    var ref: DatabaseReference!
    var sections = ["drinks", "snacks", "pharmacy",  "toiletries", "nonperishable", "produce", "meat", "dairy", "bread", "frozen"]
    var selectedCategory: Int? {
        didSet {
            _ = validateItem()
        }
    }
    
    // TODO: Add smoother transition animation
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quantityTextField.delegate = self
        self.itemNameTextField.delegate = self
        ref = Database.database().reference(withPath: "items")
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.itemNameTextField.becomeFirstResponder()
        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
    }
    
    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo!

        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        addItemViewBottomConstraint.constant = 0 - keyboardSize.height
        //self.view.frame.origin.y -= keyboardSize.height
    }
    
    func validateItem() -> Bool {
        guard let _ = selectedCategory, let _ = itemNameTextField.text else {
            addItemButton.isEnabled = false
            addItemButton.backgroundColor = .white
            addItemButton.tintColor = UIColor(displayP3Red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            return false
        }
        guard let itemName = itemNameTextField.text, itemName.count > 0 else {
            addItemButton.isEnabled = false
            addItemButton.backgroundColor = UIColor.clear
            addItemButton.tintColor = UIColor(displayP3Red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            return false
        }
        addItemButton.backgroundColor = UIColor(displayP3Red: 20.0/255.0, green: 145.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        addItemButton.tintColor = .white
        addItemButton.isEnabled = true
        return true
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        view.endEditing(true)
        if segue.identifier == "SaveItem", let itemName = itemNameTextField.text {
            let date = Date().description
            let quantity = quantityTextField.text ?? ""
            let category = sections[selectedCategory!]
            let itemToSave = Item(name: itemName, dateAdded: date, category: category, completed: false, quantity: quantity)
            
            let itemRef = self.ref.child(itemName)
            itemRef.setValue(itemToSave.toAnyObject())
        }
     }
    
    func updateButtonBorders(selected: Int) {
        print("Selected: \(sections[selected])")
        for button in buttonsArray {
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth = 4.0
        }
        buttonsArray[selected].layer.borderColor = UIColor.green.cgColor
    }
    
}

//MARK: - IBActions
extension AddItemViewController {
    @IBAction func textFieldChanged(_ sender: UITextField) {
        _ = validateItem()
    }
    
    @IBAction func itemTypeButtonTapped(_ sender: UIButton) {
        updateButtonBorders(selected: sender.tag)
        selectedCategory = sender.tag
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            quantityTextField.becomeFirstResponder()
        }
        if textField.tag == 1 {
            if validateItem() {
                performSegue(withIdentifier: "SaveItem", sender: nil)
            }
        }
        return true
    }
}

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
    var sections = ["produce", "meat", "dairy", "nonperishable", "snacks", "frozen", "toiletries"]
    var selectedCategory: Int? {
        didSet {
            validateItem()
        }
    }
    
    // TODO: Add smoother transition animation
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "items")
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillBeShown(note: Notification) {
        let userInfo = note.userInfo!

        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(keyboardSize.height)
        addItemViewBottomConstraint.constant = 0 - keyboardSize.height
        //self.view.frame.origin.y -= keyboardSize.height
    }
    
    func validateItem() {
        guard let _ = selectedCategory, let _ = itemNameTextField.text else {
            addItemButton.isEnabled = false
            addItemButton.backgroundColor = .white
            addItemButton.tintColor = UIColor(displayP3Red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            return
        }
        guard let itemName = itemNameTextField.text, itemName.count > 0 else {
            addItemButton.isEnabled = false
            addItemButton.backgroundColor = UIColor.clear
            addItemButton.tintColor = UIColor(displayP3Red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            return
        }
        addItemButton.backgroundColor = UIColor(displayP3Red: 20.0/255.0, green: 145.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        addItemButton.tintColor = .white
        addItemButton.isEnabled = true
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "SaveItem", let itemName = itemNameTextField.text {
            let date = Date().description
            let quantity = quantityTextField.text ?? ""
            let category = sections[selectedCategory!]
            let itemToSave = Item(name: itemName, dateAdded: date, category: category, completed: false, quantity: quantity)
            
            let itemRef = self.ref.child(itemName.lowercased())
            itemRef.setValue(itemToSave.toAnyObject())
        }
     }
    
    func updateButtonBorders(selected: Int) {
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
        validateItem()
    }
    
    @IBAction func itemTypeButtonTapped(_ sender: UIButton) {
        updateButtonBorders(selected: sender.tag)
        selectedCategory = sender.tag
    }
}

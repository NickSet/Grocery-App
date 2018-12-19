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
    
    var ref: DatabaseReference!
    var sections = ["produce", "meat", "dairy", "nonperishable", "snacks", "frozen", "toiletries"]
    var selectedCategory: Int? {
        didSet {
            validateItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "items")
    }
    
    func validateItem() {
        guard let category = selectedCategory else {
            addItemButton.isEnabled = false
            return
        }
        guard let itemName = itemNameTextField.text, itemName.count > 0 else {
            addItemButton.isEnabled = false
            return
        }
        addItemButton.isEnabled = true
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "SaveItem", let itemName = itemNameTextField.text {
            let date = Date().description
            print(date)
            let quantity = quantityTextField.text ?? ""
            
            let itemToSave = Item(name: itemName, dateAdded: date, quantity: quantity)
            
            if let sectionIndex = selectedCategory {
                let itemSectionRef = self.ref.child(sections[sectionIndex])
                let itemRef = itemSectionRef.child(itemName.lowercased())
                itemRef.setValue(itemToSave.toAnyObject())
                
            }
            

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
    @IBAction func itemTypeButtonTapped(_ sender: UIButton) {
        updateButtonBorders(selected: sender.tag)
        selectedCategory = sender.tag
    }
}

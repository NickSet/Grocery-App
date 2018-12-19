//
//  ViewController.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/14/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var itemTableView: UITableView!
    
    var ref: DatabaseReference!
    var sections: [String] = []
    var produceItems: [Item] = []
    var dairyItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        // TODO: Look into a more elegant way to achieve this
        ref = Database.database().reference(withPath: "items")
        
        ref.observe(.value, with: { snapshot in
            var newDairy: [Item] = []

            if let dict = snapshot.value as? NSDictionary {
                for eachSection in dict.allKeys {
                    if let section = eachSection as? String {
                        self.sections.append(section)
                    }
                }
                self.sections = self.sections.sorted(by: <)
                
                if let dairy = dict.value(forKey: "dairy") as? NSDictionary {
                    for dairyItem in dairy.allKeys {
                        let key = dairyItem as! String
                        let values = dairy.value(forKey: key) as! NSDictionary
                        let name = values["name"] as! String
                        let dateAdded = values["dateAdded"] as! String
                        let quantity = values["quantity"] as! String
                        
                        let itemToAdd = Item(name: name, key: key, dateAdded: dateAdded, quantity: quantity)
                        newDairy.append(itemToAdd)
                    }
                }
                if let produce = dict.value(forKey: "produce") as? NSDictionary {
                    for produceItem in produce {
                        print(produceItem)
                    }
                }
            }
            self.dairyItems = newDairy
            self.itemTableView.reloadData()
        })
    }
}

// MARK: - IBActions
extension ViewController {
    @IBAction func saveItem(_ segue: UIStoryboardSegue) {
        print("Back in ViewController")
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderTableViewCell {
            
            headerCell.emojiLabel.text = Constants.SectionEmoji.dairy.rawValue
            headerCell.sectionLabel.text = "Dairy"
            return headerCell
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dairyItems.count)
        return dairyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemTableViewCell {
            cell.nameLabel.text = dairyItems[indexPath.row].name
            cell.quantityLabel.text = dairyItems[indexPath.row].quantity
            cell.dateLabel.text = dairyItems[indexPath.row].dateAdded
            return cell
        } else {
            print("Couldn't Convert")
            return UITableViewCell()
        }
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


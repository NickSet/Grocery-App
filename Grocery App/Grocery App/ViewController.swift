//
//  ViewController.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/14/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit
import Firebase

private struct Objects {
    var sectionName: String!
    var sectionItems: [Item]!
}

class ViewController: UIViewController {
    
    

    @IBOutlet var addItemButton: UIButton!
    @IBOutlet var itemTableView: UITableView!
    
    var ref: DatabaseReference!
    var items: [Item] = []
    var itemsBySection: [String: [Item]] = [:]
    
    private var dataObjects: [Objects] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        // TODO: Look into a more elegant way to achieve this
        ref = Database.database().reference(withPath: "items")
        
        ref.observe(.value, with: { snapshot in
            
            var newItems: [Item] = []
            var newDataObjects: [Objects] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let item = Item(snapshot: snapshot) {
                    newItems.append(item)
                }
            }
            
            self.items = newItems
            self.itemsBySection = Dictionary(grouping: self.items) { $0.category }
            for (key, value) in self.itemsBySection {
                //print("\(key) -> \(value)")
                newDataObjects.append(Objects(sectionName: key, sectionItems: value))
            }
            newDataObjects.sort(by: { $0.sectionName < $1.sectionName })
            self.dataObjects = newDataObjects
            self.itemTableView.reloadData()
        })
        self.itemTableView.reloadData()
    }
    
    func toggleCellCheckbox(_ cell: ItemTableViewCell, isCompleted: Bool) {
        if !isCompleted {
            let currentText = cell.nameLabel.text!
            cell.accessoryType = .none
            cell.nameLabel.attributedText = nil
            cell.nameLabel.text = currentText
            cell.nameLabel.textColor = .black
            cell.quantityLabel.textColor = .black
            cell.dateLabel.textColor = .black
            cell.quantityLabel.isHidden = false
            cell.dateLabel.isHidden = false
        } else {
            // TODO: Add guard checks
            let currentText = cell.nameLabel.text!
            let strikeThroughText = NSAttributedString(string: currentText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.nameLabel.attributedText = strikeThroughText
            cell.accessoryType = .checkmark
            cell.nameLabel.textColor = .gray
            cell.quantityLabel.isHidden = true
            cell.dateLabel.isHidden = true
            
        }
    }
}

// MARK: - IBActions
extension ViewController {
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
        addItemButton.isHidden = true
    }
    
    @IBAction func saveItem(_ segue: UIStoryboardSegue) {
        addItemButton.isHidden = false
        print("Back in ViewController")
    }
    
    @IBAction func closeAddItemViewConroller(_ segue: UIStoryboardSegue) {
        addItemButton.isHidden = false
        print("Back in ViewController")
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell else { return }
        var item = dataObjects[indexPath.section].sectionItems[indexPath.row]
        let toggledCompletion = !item.completed
        item.completed = toggledCompletion
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        
        item.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = dataObjects[indexPath.section].sectionItems[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderTableViewCell {
            headerCell.sectionLabel.text = dataObjects[section].sectionName
            switch dataObjects[section].sectionName {
            case "dairy":
                headerCell.emojiLabel.text = "🧀"
                break
            case "frozen":
                headerCell.emojiLabel.text = "❄️"
                break
            case "meat":
                headerCell.emojiLabel.text = "🥩"
                break
            case "nonperishable":
                headerCell.emojiLabel.text = "🥫"
                break
            case "produce":
                headerCell.emojiLabel.text = "🥬"
                break
            case "snacks":
                headerCell.emojiLabel.text = "🍪"
                break
            case "toiletries":
                headerCell.emojiLabel.text = "🧻"
                break
            default:
                break
            }
            return headerCell
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjects[section].sectionItems.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemTableViewCell {
            let item = dataObjects[indexPath.section].sectionItems[indexPath.row]
            cell.nameLabel.text = item.name
            cell.quantityLabel.text = item.quantity
            cell.setupDateLabel(stringDate: item.dateAdded)
            toggleCellCheckbox(cell, isCompleted: item.completed)
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
        return dataObjects.count
    }
}


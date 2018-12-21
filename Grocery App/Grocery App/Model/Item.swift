//
//  Item.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/19/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let quantity: String
    //TODO: Use this class to calculate how many days since the item was added. Convert from string to date and get difference.
    let dateAdded: String
    let addedBy: String
    let category: String
    var completed: Bool
    
    init(name: String, key: String = "", dateAdded: String, category: String, completed: Bool, quantity: String = "", addedBy: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.dateAdded = dateAdded
        self.completed = completed
        self.quantity = quantity
        self.addedBy = addedBy
        self.category = category
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let dateAdded = value["dateAdded"] as? String,
            let completed = value["completed"] as? Bool,
            let quantity = value["quantity"] as? String,
            let addedBy = value["addedBy"] as? String,
            let category = value["category"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.dateAdded = dateAdded
        self.completed = completed
        self.quantity = quantity
        self.addedBy = addedBy
        self.category = category
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "dateAdded": dateAdded,
            "completed": completed,
            "quantity": quantity,
            "addedBy": addedBy,
            "category": category
        ]
    }
}

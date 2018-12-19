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
    let dateAdded: String
    
    init(name: String, key: String = "", dateAdded: String, quantity: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.dateAdded = dateAdded
        self.quantity = quantity
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let dateAdded = value["dateAdded"] as? String,
            let quantity = value["quantity"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.dateAdded = dateAdded
        self.quantity = quantity
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "dateAdded": dateAdded,
            "quantity": quantity
        ]
    }
}

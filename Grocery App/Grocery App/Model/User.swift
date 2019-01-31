//
//  User.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 1/10/19.
//  Copyright © 2019 Nicholas Setliff. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let firstInitial: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
        firstInitial = String(email.first!)
    }
    
    init(uid: String, email: String, firstInitial: String) {
        self.uid = uid
        self.email = email
        self.firstInitial = firstInitial
    }
}

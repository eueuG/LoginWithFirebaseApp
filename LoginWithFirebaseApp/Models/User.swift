//
//  User.swift
//  LoginWithFirebaseApp
//
//  Created by 野田凜太郎 on 2021/03/28.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}

//
//  User.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

//import Foundation

class MyUser {
    var displayName: String?
    var email: String?
    var photoURL: String?
    var address: String?
    var coupons: Int?
    var gender: String?
    var height: Any?
    var phone: String?
    var size: Any?
    
    init(displayName: String?, email: String?, photoURL: String?, address: String?, coupons: Int?, gender: String?, height: Any?, phone: String?, size: Any?){
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.address = address
        self.coupons = coupons
        self.gender = gender
        self.height = height
        self.phone = phone
        self.size = size
    }
}


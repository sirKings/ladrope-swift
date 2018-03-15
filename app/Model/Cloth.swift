//
//  Cloth.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//
import Foundation

struct Cloth: Codable {
    let name: String
    let clothKey: String
    //let cost: Any
    let gender: String
    let image1: String
    let image2: String
    let image3: String
    let image4: String
    let label: String
    let labelEmail: String
    let labelId: String
    let labelPhone: String
    let likes: Int
    let numComment: Int
    let numSold: Int
    let price: Int
    let rating: Double
    let tags: String
    let tailorKey: String
    let time: Int
    let fabricType: String
    let description: String
    //let options: Any
    var cartKey: String?
    var selectedOption: [Dictionary<String, String?>]?
    var liked: Bool? = false
    let likers: Dictionary<String, Bool>
    
    
//    init(name: String?, clothKey: String?, cost: String?, gender: String?, image1: String?,
//    image2: String?, image3: String?, image4: String?, label: String?, likers: Dictionary<String, Bool>?,
//    labelEmail: String?, labelPhone: String?, labelId: String?,
//    likes: Int?, numComment: Int?, numSold: Int?, price: Int?,
//    rating: Double?, tags: String?, fabricType: String?, description: String?,
//    tailorKey: String?, time: Any?, options: Any?, cartKey: String?, liked: Bool?, selectedOption: Any?){
//        self.clothKey = clothKey
//        self.cost = cost
//        self.gender = gender
//        self.image1 = image1
//        self.image2 = image2
//        self.image3 = image3
//        self.image4 = image4
//        self.label = label
//        self.description = description
//        self.labelEmail = labelEmail
//        self.labelId = labelId
//        self.labelPhone = labelPhone
//        self.likes = likes
//        self.numComment = numComment
//        self.numSold = numSold
//        self.price = price
//        self.rating = rating
//        self.tags = tags
//        self.tailorKey = tailorKey
//        self.time = time
//        self.name = name
//        self.fabricType = fabricType
//        self.options = options
//        self.cartKey = cartKey
//        self.selectedOption = selectedOption
//        self.liked = liked!
//        self.likers = likers
//
//    }
}


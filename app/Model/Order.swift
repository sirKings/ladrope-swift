//
//  Order.swift
//  app
//
//  Created by MAC on 3/27/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import Foundation

class Order: Codable {
    var accepted: Bool?
    var clientAddress: String?
    var clothId: String?
    var cost: Int?
    var date: String?
    var displayName: String?
    var email: String?
    var image1: String?
    var label: String?
    var labelEmail: String?
    var labelId: String?
    var labelPhone: String?
    var name: String?
    var orderId: String?
    var ordersKey: String?
    var price: Int?
    var size: Dictionary<String, String>?
    var startDate: String?
    var status: String?
    var tailorDate: String?
    var tailorOrderKey: String?
    var user: String?
    var userOrderKey: String?
    var time: Int?
    var options: [Dictionary<String, String?>]?
}

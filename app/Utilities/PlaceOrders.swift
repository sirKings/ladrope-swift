//
//  PlaceOrders.swift
//  app
//
//  Created by MAC on 3/27/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import Foundation
import Firebase
import SCLAlertView
import SVProgressHUD
import CodableFirebase

func placeOrders(cloths: [Cloth], ref: String, onComplete: @escaping (Bool)-> Void){
    SVProgressHUD.show()
    let userSizeRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("size")
    
    userSizeRef.observeSingleEvent(of: .value){
        res in
        
        var size = Dictionary<String, String>()
        size["size"] = "hello world"
        
        if res.exists() {
            submitOrder(cloths: cloths, ref: ref, size: size){
                status in
                if status {
                    onComplete(true)
                }
            }
        }else{
            saveOrder(cloths: cloths, ref: ref){
                status in
                if status {
                    onComplete(true)
                }
            }
        }
    }
    
}

func submitOrder(cloths: [Cloth], ref: String, size: Dictionary<String, String>, onComplete: (Bool)-> Void){
    for cloth in cloths {
        print(cloth)
        let order = Order()
        
        let userOrderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders")
        let userOrderKey = userOrderRef.childByAutoId().key
        let orderRef = Database.database().reference().child("orders")
        let orderKey = orderRef.childByAutoId().key
        let tailorOrderRef = Database.database().reference().child("tailors").child(cloth.labelId).child("orders")
        let tailorOrderKey = tailorOrderRef.childByAutoId().key
        
        order.user = Auth.auth().currentUser!.uid
        order.userOrderKey = userOrderKey
        order.ordersKey = orderKey
        order.status = "Pending"
        order.image1 = cloth.image1
        order.options = cloth.selectedOption
        order.size = size
        order.tailorOrderKey = tailorOrderKey
        order.email = currentUser!.email
        order.orderId = ref
        order.displayName = currentUser!.displayName
        order.clientAddress = currentUser!.address
        order.clothId = cloth.clothKey
        order.cost = cloth.cost
        order.date = getTime(num: cloth.time + 2)
        order.startDate = getTime(num: 0)
        order.tailorDate = getTime(num: cloth.time)
        order.price = cloth.price
        order.label = cloth.label
        order.labelEmail = cloth.labelEmail
        order.labelId = cloth.labelId
        order.labelPhone = cloth.labelPhone
        order.name = cloth.name
        
        let data = try! FirebaseEncoder().encode(order)
        
        userOrderRef.child(userOrderKey).setValue(data){
            (error, res) in
            if error == nil {
                tailorOrderRef.child(tailorOrderKey).setValue(data){
                    (error, res) in
                    if error == nil {
                        orderRef.child(orderKey).setValue(data){
                            (error, res) in
                            if error == nil {
                                SVProgressHUD.dismiss()
                                SCLAlertView().showSuccess("Success!", subTitle: "Your order has been submitted and processing started. Thanks for your patronage")
                            }
                        }
                    }
                }
            }else{
                //retry
            }
        }
    }
    onComplete(true)
}

func saveOrder(cloths: [Cloth], ref: String, onComplete: @escaping (Bool)-> Void){
    //print(currentUser!)
    for cloth in cloths{
        let userOrderKey = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("savedOrders").childByAutoId().key
        
        let order = Order()
        
        order.user = Auth.auth().currentUser?.uid
        order.userOrderKey = userOrderKey
        order.status = "Not Submitted"
        order.image1 = cloth.image1
        order.options = cloth.selectedOption
        order.email = currentUser!.email!
        order.orderId = ref
        order.displayName = currentUser!.displayName!
        order.clientAddress = currentUser!.address
        order.clothId = cloth.clothKey
        order.cost = cloth.cost
        order.startDate = getTime(num: 0)
        order.price = cloth.price
        order.time = cloth.time
        order.label = cloth.label
        order.labelEmail = cloth.labelEmail
        order.labelId = cloth.labelId
        order.labelPhone = cloth.labelPhone
        order.name = cloth.name
        
        let data = try! FirebaseEncoder().encode(order)
        
        Database.database().reference().child("users").child(order.user!).child("savedOrders").child(userOrderKey).setValue(data){
            (error, res) in
            if error == nil {
                SVProgressHUD.dismiss()
                
                SCLAlertView().showSuccess("Success!", subTitle: "Your order has been saved, However you need to take your measurement for your order to be processed. Go to user tab and take your measurement")
            } else{
                print(error)
            }
        }
        
    }
    onComplete(true)
    
}

func submitPendingOrder(cloth: Order, ref: DatabaseReference){
    SVProgressHUD.show()
        
        let order = Order()
        
        let userOrderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders")
        let userOrderKey = userOrderRef.childByAutoId().key
        let orderRef = Database.database().reference().child("orders")
        let orderKey = orderRef.childByAutoId().key
        let tailorOrderRef = Database.database().reference().child("tailors").child(cloth.labelId!).child("orders")
        let tailorOrderKey = tailorOrderRef.childByAutoId().key
        
        order.user = Auth.auth().currentUser!.uid
        order.userOrderKey = userOrderKey
        order.ordersKey = orderKey
        order.status = "Pending"
        order.image1 = cloth.image1
        order.options = cloth.options
        order.size = cloth.size
        order.tailorOrderKey = tailorOrderKey
        order.email = currentUser!.email
        order.orderId = cloth.orderId
        order.displayName = currentUser!.displayName
        order.clientAddress = currentUser!.address
        order.clothId = cloth.clothId
        order.cost = cloth.cost
        order.date = getTime(num: cloth.time! + 2)
        order.startDate = getTime(num: 0)
        order.tailorDate = getTime(num: cloth.time!)
        order.price = cloth.price
        order.label = cloth.label
        order.labelEmail = cloth.labelEmail
        order.labelId = cloth.labelId
        order.labelPhone = cloth.labelPhone
        order.name = cloth.name
        
        let data = try! FirebaseEncoder().encode(order)
        
        userOrderRef.child(userOrderKey).setValue(data){
            (error, res) in
            if error == nil {
                tailorOrderRef.child(tailorOrderKey).setValue(data){
                    (error, res) in
                    if error == nil {
                        orderRef.child(orderKey).setValue(data){
                            (error, res) in
                            if error == nil {
                                SVProgressHUD.dismiss()
                                SCLAlertView().showSuccess("Success!", subTitle: "Your order has been submitted and processing started. Thanks for your patronage")
                                ref.setValue(nil){
                                    (error, res) in
                                    if error != nil {
                                        print(error)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }else{
                //retry
            }
        }
}

func getTime(num: Int)-> String{
    let date = Date()
    let calender = Calendar.current
    let tempTime = calender.date(byAdding: .day, value: num, to: date)
    
    let time = String(describing: tempTime!)
    
    return time
}



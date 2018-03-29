//
//  UserServices.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//
import Firebase
import CodableFirebase

var currentUser: MyUser?

func saveUser(user: MyUser, uid: String){
    let myUser: Dictionary<String, Any> = ["email": user.email!, "displayName": user.displayName!, "gender": user.gender!, "photoURL": user.photoURL ?? "default"]
    
    let userRef = Database.database().reference().child("users").child(uid)
    userRef.observeSingleEvent(of: .value){
        (snapshot) in
        if snapshot.value != nil {
            userRef.setValue(myUser)
        }else{
            print("User exists")
        }
    }
}

func checkAndSubmitPendingOrders(){
   let savedOrderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("savedOrders")
    savedOrderRef.observe(.childAdded){
        snapshot in
        
        guard let value = snapshot.value else { return }
        
        do {
            let cloth = try FirebaseDecoder().decode(Order.self, from: value)
            //print(cloth)
            submitPendingOrder(cloth: cloth, ref: savedOrderRef.child(cloth.userOrderKey!))
            
        } catch let error {
            print(error)
            
        }
    }
    
    
}

func updateCoupon(){
    var coupon: Int?
    if currentUser?.coupons != nil {
        coupon = currentUser?.coupons
    }else{
        coupon = 0
    }
    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("coupons").setValue((coupon! + 1))
}

func getUser(){
    let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    userRef.observe(.value){
        snapshot in
        
        guard let value = snapshot.value else { return }
        do {
            let user = try FirebaseDecoder().decode(MyUser.self, from: value)
            //print(user)
            currentUser = user
        } catch let error {
            print(error)
        }
        
    }
}

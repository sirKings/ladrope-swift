//
//  UserServices.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//
import FirebaseDatabase

func saveUser(user: MyUser, uid: String){
    let userRef = Database.database().reference().child("users").child(uid)
    userRef.observeSingleEvent(of: .value){
        (snapshot) in
        if snapshot.value != nil {
            userRef.setValue(user)
        }else{
            print("User exists")
        }
    }
}

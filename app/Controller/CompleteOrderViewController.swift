//
//  CompleteOrderViewController.swift
//  app
//
//  Created by MAC on 3/28/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import SVProgressHUD
import CodableFirebase
import SCLAlertView

protocol CompleteOrderProtocol {
    func closeOrderDetails()
}

class CompleteOrderViewController: UIViewController {
    
    var order: Order?
    var rating: Double = 0.0
    
    var delegate: CompleteOrderProtocol?
    
    
    @IBOutlet var completeRating: CosmosView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.7)
        
        completeRating.didFinishTouchingCosmos = {
            rating in
            self.rating = rating
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func completeOrder(_ sender: Any) {
        rateCloth(rating: rating)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func rateCloth(rating: Double){
        SVProgressHUD.show()
        
        let clothRef = Database.database().reference().child("cloths").child(GENDER).child((order?.clothId)!)
        
        clothRef.observeSingleEvent(of: .value){
            res in
            
            guard let value = res.value else {
                SVProgressHUD.dismiss()
                self.updateOrders()
                return
                
            }
            do {
                let cloth = try FirebaseDecoder().decode(Cloth.self, from: value)
                self.updateRating(cloth: cloth, rating: rating)
                SVProgressHUD.dismiss()
            } catch let error {
                print(error)
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    func updateRating(cloth: Cloth, rating: Double) {
        let ratingRef = Database.database().reference().child("cloths").child(GENDER).child(cloth.clothKey).child("rating")
        let newRate = (cloth.rating + rating)/2
        ratingRef.setValue(newRate){
            (error, res) in
            if error == nil {
                self.updateCloth(cloth: cloth)
            }
            
        }
    }
    
    func updateCloth(cloth: Cloth){
        let numSoldRef = Database.database().reference().child("cloths").child(GENDER).child(cloth.clothKey).child("numSold")
        let newNumSold = cloth.numSold + 1
        numSoldRef.setValue(newNumSold){
            (error, res) in
            if error == nil {
                self.updateOrders()
            }
        }
        
    }
    
    
    func updateOrders(){
        SVProgressHUD.show()
        
        order?.status = "Completed"
        
        let data = try! FirebaseEncoder().encode(order)
        
        let orderRef = Database.database().reference().child("orders").child((order?.ordersKey)!)
        let userOrderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child((order?.userOrderKey)!)
        let tailorOrderRef = Database.database().reference().child("tailors").child((order?.labelId)!).child("orders").child((order?.tailorOrderKey)!)
        
        orderRef.setValue(nil){
            (error, res) in
            if error == nil {
                userOrderRef.setValue(nil){
                    (error, res) in
                        if error == nil {
                            tailorOrderRef.setValue(nil){
                                (error, res) in
                                if error == nil {
                                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("completedorders").childByAutoId().setValue(data){
                                        (error, res) in
                                        if error == nil {
                                            Database.database().reference().child("completedOrders").childByAutoId().setValue(data){
                                                (error, res) in
                                                if error == nil {
                                                    Database.database().reference().child("tailors").child((self.order?.labelId)!).child("completedOrders").childByAutoId().setValue(data){
                                                        (error, res) in
                                                        if error == nil {
                                                            SVProgressHUD.dismiss()
                                                            SCLAlertView().showSuccess("Success", subTitle: "Thanks for your patronage")
                                                            
                                                            self.dismiss(animated: true){
                                                                self.delegate?.closeOrderDetails()
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    
                }
            }
        }
    }

}

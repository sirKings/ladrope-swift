//
//  UserViewController.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CodableFirebase

class UserViewController: UIViewController {
    
    var user: MyUser?
    
    
    @IBOutlet weak var userHeight: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userCoupons: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        getUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditUser(_ sender: Any) {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    @IBAction func MeasurePressed(_ sender: Any) {
    }

     @IBAction func Logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }catch let error{
            print(error)
        }
        
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToEdit"{
            let eVC = segue.destination as! EditUserViewController
            eVC.user = user
        }
    }
    
    func getUser(){
        let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        userRef.observe(.value){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let user = try FirebaseDecoder().decode(MyUser.self, from: value)
                print(user)
                SVProgressHUD.dismiss()
                self.user = user
                self.setUp()
            } catch let error {
                print(error)
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    func setUp(){
        userName.text = user?.displayName
        userEmail.text = user?.email
        userAddress.text = user?.address
        userCoupons.text = "Coupons: \(user?.coupons ?? 0)"
        userPhone.text = user?.phone
        
        let imgUrl = URL(string: (user?.photoURL)!)
        
        userImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "profileImage"), options: nil, progressBlock:nil, completionHandler: nil)
    }
   

}

//
//  CartViewController.swift
//  app
//
//  Created by MAC on 3/15/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD
import CodableFirebase

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartCellProtocol {
    
    
    var itemArray = [Cloth]()
    var price: Int?
    
    @IBOutlet weak var discountedTotal: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cartList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        getCartItems()
        
        cartList.delegate = self
        cartList.dataSource = self
        cartList.register(UINib(nibName: "CartViewCell", bundle: nil), forCellReuseIdentifier: "cartViewCell")
        cartList.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartViewCell", for: indexPath) as! CartViewCell
        
        cell.label.text = itemArray[indexPath.row].label.capitalized
        cell.name.text = itemArray[indexPath.row].name.capitalized
        cell.price.text = "Price: NGN\(itemArray[indexPath.row].price).00"
        
        let imgUrl = URL(string: itemArray[indexPath.row].image1)
        cell.cartImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock:nil, completionHandler: nil)
        
        cell.delegate = self
        cell.cloth = itemArray[indexPath.row]
        return cell
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startPayment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startPayment" {
            let PVC = segue.destination as! PaymentViewController
            PVC.price = price
            PVC.cloths = itemArray
            PVC.sender = true
        }
    }
    
    func removeItem(cell: CartViewCell) {
        SVProgressHUD.show()
        let cartRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("cart")
        cartRef.child((cell.cloth?.cartKey)!).setValue(nil){
            (error, res) in
            if error == nil {
                self.itemArray.removeAll()
                self.getCartItems()
            }
        }
    }
    
    func getCartItems() {
        let cartRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("cart")
        cartRef.observe(.childAdded, with: updateItems)
    }
    
    func updateItems(snapshot: DataSnapshot){
        print(snapshot)
        guard let value = snapshot.value else { return }
        do {
            let cloth = try FirebaseDecoder().decode(Cloth.self, from: value)
            itemArray.append(cloth)
            SVProgressHUD.dismiss()
            cartList.reloadData()
            fixPrice()
        } catch let error {
            print(error)
        }
    }
    
    func getTotal() -> Int {
        var total = 0
        for item in itemArray {
            total = total + item.price
        }
       
        return total
    }
    
    func fixPrice() {
        if checkCoupon() {
            //strike through
            let attributeString =  NSMutableAttributedString(string: "Total: NGN\(getTotal()).00")
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            total.attributedText = attributeString
            
            discountedTotal.text = "Discounted Price: NGN\(Int(Double(getTotal()) * 0.95)).00"
            price = Int(Double(getTotal()) * 0.95)
        }else {
            total.text = "Total: NGN\(getTotal()).00"
            discountedTotal.text = ""
            price = getTotal()
        }
        
    }
    
    func checkCoupon() -> Bool{
        print(currentUser?.coupons)
        if currentUser?.coupons != nil && currentUser!.coupons! > 0 {
            print("There is coupon")
            return true
        }else {
            print("there is no coupon")
            return false
        }
    }

}

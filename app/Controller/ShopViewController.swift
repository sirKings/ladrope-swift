//
//  FirstViewController.swift
//  app
//
//  Created by MAC on 3/8/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SVProgressHUD
import SCLAlertView

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCelDelegate, FilterDelegate {
    
    
    var clothList = [Cloth]()
    var selectedClothKey: String?
    var selectedCloth: Cloth?
    var isCartItems: Bool = false
    
    @IBOutlet weak var noCartItems: UILabel!
    @IBOutlet weak var shopList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        let ref = Database.database().reference().child("cloths").child(GENDER).queryOrdered(byChild: "date")
        getCloth(clothRef: ref)
        getNumCartItems()
        // Do any additional setup after loading the view, typically from a nib.
        shopList.delegate = self
        shopList.dataSource = self
        shopList.register(UINib(nibName: "ShopViewCell", bundle: nil), forCellReuseIdentifier: "shopViewCell")
        
        shopList.separatorStyle = .none
        shopList.rowHeight = 415.0
        
    }

    @IBAction func cartBtnPressed(_ sender: Any) {
        if isCartItems {
            performSegue(withIdentifier: "goToCart", sender: self)
        }else{
            SCLAlertView().showError("Oops", subTitle: "There is nothing in your cart, select designs you like and add to cart")
        }
    }
    @IBAction func filterBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "filter", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return clothList.count
        if clothList.count == 0 {
            tableView.setEmptyMessage("There are no matching items for now. Try again later")
        } else {
            tableView.restore()
        }
        return clothList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCloth = clothList[indexPath.section]
        performSegue(withIdentifier: "goToClothFromShop", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopViewCell", for: indexPath) as! ShopViewCell
        var cloth = clothList[indexPath.section]
        
        let imgUrl = URL(string: cloth.image1)
        
        cell.numLikes.text = "\(cloth.likes)"
        cell.shopLabel.text = cloth.label.capitalized
        cell.shopPrice.text = "NGN\(cloth.price).00"
        cell.shopName.text = cloth.name.capitalized
        cell.shopRating.rating = cloth.rating
        cell.shopRating.text = "(\(cloth.numSold))"
        cell.numComment.text = "\(cloth.numComment)"
        cell.shopImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock:nil, completionHandler: nil)
        
        if getLikeStatus(likers: cloth.likers) {
            cell.likeImage.setImage(#imageLiteral(resourceName: "filledlike"), for: .normal)
            cloth.liked = true
        }else{
            cell.likeImage.setImage(#imageLiteral(resourceName: "emptylike"), for: .normal)
            cloth.liked = false
        }
        cell.delegate = self
        cell.cloth = cloth
        
        return cell
    }
    
    func getCloth(clothRef: DatabaseQuery){
        
        clothList.removeAll()
        shopList.reloadData()
        
        clothRef.observe(.childAdded){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let cloth = try FirebaseDecoder().decode(Cloth.self, from: value)
                //print(cloth)
                self.clothList.append(cloth)
                SVProgressHUD.dismiss()
                self.shopList.reloadData()
            } catch let error {
                print(error)
            }
            
        }
        
        clothRef.observe(.value){
            snapshot in
            
            if snapshot.hasChildren(){
                
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func getLikeStatus(likers: Dictionary<String, Bool>) -> Bool{
        if likers[Auth.auth().currentUser!.uid] != true {
            return false
        }else{
            return true
        }
    }
    
    func likeBtnPressed(cell: ShopViewCell) {
        if (cell.cloth?.liked)! {
            saveLikeStatus(status: false, cloth: cell.cloth!)
            cell.cloth?.liked = false
            cell.likeImage.setImage(#imageLiteral(resourceName: "emptylike"), for: .normal)
            let numLike = Int(cell.numLikes.text!)! - 1
            cell.numLikes.text = "\(numLike)"
        }else{
            saveLikeStatus(status: true, cloth: cell.cloth!)
            cell.cloth?.liked = true
            cell.likeImage.setImage(#imageLiteral(resourceName: "filledlike"), for: .normal)
            let numLike = Int(cell.numLikes.text!)! + 1
            cell.numLikes.text = "\(numLike)"
        }
    }
    
    
    func shareBtnPressed(cell: ShopViewCell) {
        let image1 = cell.shopImage
        
        let dataToShare = [image1?.image, "https://ladrope.com/cloth/\(cell.cloth!.clothKey)" ] as [Any]
        
        let activityController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        self.present(activityController, animated: true){
            updateCoupon()
        }
    }
    
    func commentBtnPressed(cell: ShopViewCell) {
        selectedClothKey = cell.cloth?.clothKey
        performSegue(withIdentifier: "goToCommentFromShop", sender: self)
        
    }
    
    func saveLikeStatus(status: Bool, cloth: Cloth){
        let clothRef = Database.database().reference().child("cloths").child(GENDER).child(cloth.clothKey)
        if status {
            clothRef.child("likers").child((Auth.auth().currentUser?.uid)!).setValue(true){
                (error, dataref) in
                if error == nil {
                    let numLikes = cloth.likes + 1
                    clothRef.child("likes").setValue(numLikes)
                    
                }
            }
            
        }else{
            clothRef.child("likers").child((Auth.auth().currentUser?.uid)!).setValue(nil){
                (error, dataref) in
                if error == nil {
                    let numLikes = cloth.likes - 1
                    clothRef.child("likes").setValue(numLikes)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToCommentFromShop"{
            let commentCV = segue.destination as! CommentViewController
            commentCV.key = selectedClothKey
            
        }
        
        if segue.identifier == "goToClothFromShop"{
            let clothCV = segue.destination as! ClothViewController
            clothCV.cloth = selectedCloth
        }
        
        if segue.identifier == "filter" {
            let FVC = segue.destination as! FilterViewController
            FVC.delgate = self
        }
        
    }
    
    func getNumCartItems() {
        let cartRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("cart")
        
        cartRef.observe(.value){
            snapshot in
            if snapshot.exists() {
                self.noCartItems.text = "\(snapshot.childrenCount)"
                self.isCartItems = true
            }else{
                self.noCartItems.text = "0"
                self.isCartItems = false
            }
            
        }
    }
    
    func filter(query: DatabaseQuery) {
        SVProgressHUD.show()
        print("filter started")
        getCloth(clothRef: query)
    }


}


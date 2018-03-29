//
//  ClothViewController.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Cosmos
import CodableFirebase

class ClothViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cloth: Cloth?
    var imageList = [String]()
    //var activityController: UIActivityViewController?
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var ratingbar: CosmosView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var numComments: UILabel!
    @IBOutlet weak var productionTime: UILabel!
    @IBOutlet weak var fabricType: UILabel!
    @IBOutlet weak var likeImage: UIButton!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var titleBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleBar.title = cloth?.name.capitalized
        SVProgressHUD.show()
        getCloth(key: cloth!.clothKey)
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! ImageCollectionViewCell
        let imageUrl = URL(string: imageList[indexPath.row])
        myCell.image.kf.setImage(with: imageUrl)
        
        return myCell
    }

    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Share(_ sender: UIButton) {
        let image1 = UIImageView()
        let url = URL(string: cloth!.image1)
        image1.kf.setImage(with: url )
        
        let dataToShare = [image1.image, "https://ladrope.com/cloth/\(cloth!.clothKey)" ] as [Any]
        
        let activityController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        self.present(activityController, animated: true){
            updateCoupon()
        }
    }
    
    @IBAction func Comment(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCommentFromCloth", sender: self)
    }
    @IBAction func OrderNow(_ sender: UIButton) {
        performSegue(withIdentifier: "goToOptions", sender: self)
    }
    @IBAction func Like(_ sender: UIButton) {
        if (cloth?.liked)! {
            saveLikeStatus(status: false)
            cloth?.liked = false
            likeImage.setImage(#imageLiteral(resourceName: "emptylike"), for: .normal)
        }else{
            saveLikeStatus(status: true)
            cloth?.liked = true
            likeImage.setImage(#imageLiteral(resourceName: "filledlike"), for: .normal)
        }
    }
    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToCommentFromCloth" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.key = cloth!.clothKey
        }
        
        if segue.identifier == "goToOptions" {
            let optionsVC = segue.destination as! OptionsViewController
            optionsVC.cloth = cloth
        }
        
    }
    
    func setup(){
        numComments.text = String(describing: cloth!.numComment)
        numLikes.text = String(describing: cloth!.likes)
        label.text = cloth!.label.capitalized
        name.text = cloth!.name.capitalized
        price.text = "NGN\(cloth?.price ?? 00).00"
        productionTime.text = "\((cloth?.time)! + 2) days"
        ratingbar.text = "(\(cloth?.numSold ?? 0))"
        ratingbar.rating = (cloth?.rating)!
        fabricType.text = cloth!.fabricType.capitalized
        desc.text = cloth!.description
        
        if getLikeStatus() {
            likeImage.setImage(#imageLiteral(resourceName: "filledlike"), for: .normal)
            cloth?.liked = true
        }else{
            likeImage.setImage(#imageLiteral(resourceName: "emptylike"), for: .normal)
            cloth?.liked = false
        }
        imageCollection.reloadData()
    }
    
    
    
    func getLikeStatus() -> Bool{
        if cloth!.likers[Auth.auth().currentUser!.uid] != true {
            return false
        }else{
            return true
        }
    }
    
    func saveLikeStatus(status: Bool){
        let clothRef = Database.database().reference().child("cloths").child(GENDER).child(cloth!.clothKey)
        if status {
            clothRef.child("likers").child((Auth.auth().currentUser?.uid)!).setValue(true){
                (error, dataref) in
                if error == nil {
                    let numLikes = self.cloth!.likes + 1
                    clothRef.child("likes").setValue(numLikes)
                }
            }
            
        }else{
            clothRef.child("likers").child((Auth.auth().currentUser?.uid)!).setValue(nil){
                (error, dataref) in
                if error == nil {
                    let numLikes = self.cloth!.likes - 1
                    clothRef.child("likes").setValue(numLikes)
                }
            }
        }
    }
    
    func getCloth(key: String){
        let clothRef = Database.database().reference().child("cloths").child(GENDER).child(key)
        clothRef.observe(.value){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let cloth = try FirebaseDecoder().decode(Cloth.self, from: value)
                //print(cloth)
                self.cloth = cloth
                SVProgressHUD.dismiss()
                self.imageList.append(cloth.image1)
                self.imageList.append(cloth.image2)
                self.imageList.append(cloth.image3)
                self.imageList.append(cloth.image4)
                self.setup()
            } catch let error {
                print(error)
            }
        }
    }

}

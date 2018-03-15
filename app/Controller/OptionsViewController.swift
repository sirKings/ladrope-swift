//
//  OptionsViewController.swift
//  app
//
//  Created by MAC on 3/14/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CodableFirebase
import SCLAlertView

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noOptionNotification: UILabel!
    var cloth: Cloth?
    @IBOutlet weak var optionsList: UITableView!
    var optionsArray = [Option]()
    var selectedOptions = [Dictionary<String, String?>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noOptionNotification.isHidden = true
        
        SVProgressHUD.show()
        checkForOptions()
        optionsList.delegate = self
        optionsList.dataSource = self
        optionsList.register(UINib(nibName: "OptionsViewCell", bundle: nil), forCellReuseIdentifier: "optionViewCell")
        optionsList.separatorStyle = .none

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOptions.removeAll()
        let opt: Dictionary<String, String?>?
        opt = ["name": optionsArray[indexPath.row].name, "image": optionsArray[indexPath.row].image]
        selectedOptions.append(opt!)
        
        let cell: OptionsViewCell = optionsList.cellForRow(at: indexPath)! as! OptionsViewCell
        cell.statusText.text = "Selected"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: OptionsViewCell = optionsList.cellForRow(at: indexPath)! as! OptionsViewCell
        cell.statusText.text = "Select"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionViewCell", for: indexPath) as! OptionsViewCell
        
        optionCell.name.text = optionsArray[indexPath.row].name
        let imagUrl = URL(string: optionsArray[indexPath.row].image!)
        optionCell.optionImage.kf.setImage(with: imagUrl, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock:nil, completionHandler: nil)
        
        return optionCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Explore available options"
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        let cartRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("cart")
        let cartKey = cartRef.childByAutoId().key
        
        cloth?.cartKey = cartKey
        cloth?.selectedOption = selectedOptions
        
        let data = try! FirebaseEncoder().encode(cloth)
        cartRef.child(cartKey).setValue(data){
            (error, ref) in
            if error == nil {
                SCLAlertView().showSuccess("Success", subTitle: "Product has been added to your cart")
            }else {
                 SCLAlertView().showError("Ooops", subTitle: "Something went wrong, try again later")
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func placeOrder(_ sender: UIButton) {
        
    }
    
    func getOptions(){
        
        let optionsRef = Database.database().reference().child("cloths").child(GENDER).child((cloth?.clothKey)!).child("options")
        optionsRef.observe(.childAdded){
            snapshot in
            
            if let snapVal = snapshot.value as? Dictionary<String,String>{
                print(snapVal)
                let name = snapVal["name"]
                let image = snapVal["image"]

                let opt = Option()
                opt.name = name
                opt.image = image
                self.optionsArray.append(opt)
                SVProgressHUD.dismiss()
                self.optionsList.reloadData()

            }else{
                //print("No options found")
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func checkForOptions() {
        let optionsRef = Database.database().reference().child("cloths").child(GENDER).child((cloth?.clothKey)!).child("options")
        optionsRef.observe(.value){
            snapshot in
            
            if snapshot.hasChildren(){
                self.getOptions()
            }else{
                SVProgressHUD.dismiss()
                self.noOptionNotification.isHidden = false
                self.optionsList.isHidden = true
                let x = self.optionsList.frame.minX
                let y = self.optionsList.frame.minY
                let width = self.optionsList.frame.width
                self.optionsList.frame = CGRect(x: x, y: y, width: width, height: 0)
            }
        }
    }
    
    
 

}

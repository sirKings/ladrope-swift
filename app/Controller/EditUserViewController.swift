//
//  EditUserViewController.swift
//  app
//
//  Created by MAC on 3/15/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import SCLAlertView
import SVProgressHUD
import Firebase
import CodableFirebase

class EditUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var user: MyUser?
    var unitList = ["Inches", "Meters", "Feet"]
    var unit: String?
    
    @IBOutlet weak var showUnit: UIButton!
    @IBAction func saveUpdates(_ sender: UIButton) {
        if editName.text == ""{
            SCLAlertView().showError("Error", subTitle: "Enter name")
        }else{
            if editPhone.text == "" {
                SCLAlertView().showError("Error", subTitle: "Enter Phone number")
            }else{
                if editAddress.text == "" {
                    SCLAlertView().showError("Error", subTitle: "Enter Address")
                }else{
                    if editHeight.text == "" {
                        SCLAlertView().showError("Error", subTitle: "Enter height")
                    }else {
                        if unit == nil {
                            SCLAlertView().showError("Error", subTitle: "Select unit for your height")
                        }else{
                            SVProgressHUD.show()
                            saveUserInfo()
                        }
                    }
                }
            }
        }
    }
    @IBOutlet weak var unitText: UILabel!
    @IBOutlet weak var editAddress: UITextView!
    var pickUnit = UIPickerView()
    @IBOutlet weak var editHeight: UITextField!
    @IBOutlet weak var editPhone: UITextField!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editEmail: UILabel!
    @IBOutlet weak var editImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickUnit.delegate = self
        pickUnit.dataSource = self
        setup()
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unit = unitList[row]
        pickUnit.endEditing(true)
        pickUnit.isHidden = true
        showUnit.setTitle(unit, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitList[row]
    }
    
    @IBAction func showPickerPressed(_ sender: Any) {
        pickUnit.isHidden = false
        showPicker()
    }
    func showPicker(){
        pickUnit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickUnit)
        
        pickUnit.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickUnit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pickUnit.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func saveUserInfo(){
        var newUnit: String?
        switch unit {
        case "Inches"?:
            newUnit = "inc"
        case "Meters"?:
            newUnit = "inc"
        case "Feet"?:
            newUnit = "inc"
        default:
            newUnit = nil
        }
        
        let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        userRef.updateChildValues([
            "displayName": editName.text!,
            "address": editAddress.text,
            "phone": editPhone.text!]){
                (error, res) in
                if error == nil {
                    userRef.child("height").updateChildValues([
                        "height": self.editHeight.text!,
                        "unit": newUnit!]){
                            (err, ress) in
                            if err == nil {
                                SVProgressHUD.dismiss()
                                SCLAlertView().showSuccess("Success", subTitle: "Updates saved")
                            }
                        }
                }else{
                    SVProgressHUD.dismiss()
                    SCLAlertView().showError("Error", subTitle: "Update failed, try again later")
            }
        }
    }
    
    func setup(){
        editName.text = user?.displayName
        editPhone.text = user?.phone
        editAddress.text = user?.address
        
        let imgUrl = URL(string: (user?.photoURL)!)
        editImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "profileImage"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FilterViewController.swift
//  app
//
//  Created by MAC on 3/29/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

protocol FilterDelegate {
    func filter(query: DatabaseQuery)
}

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //0 = gender while 1 = type
    var pickerType = 0
    
    
    var delgate: FilterDelegate?
    var gender: String?
    var type: String?
    
    var genderList = ["male", "female"]
    var typeList = ["Casual wears", "Corporate wears", "Traditional wears", "Shirts", "Trousers", "Gown", "Wedding Outfits", "Suits", "Ankara"]
    
    var genderPicker = UIPickerView()
    var typePicker = UIPickerView()
    
    @IBOutlet var typeText: UIButton!
    @IBOutlet var filterText: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.7)
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.white
        
        typePicker.dataSource = self
        typePicker.delegate = self
        typePicker.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterByGender(_ sender: Any) {
        pickerType = 0
        showPicker()
    }
    
    @IBAction func filterByType(_ sender: Any) {
        pickerType = 1
        showPicker()
    }
    @IBAction func applyFilter(_ sender: Any) {
        
        if gender != nil && type != nil {
            let clas = getClass(type: type!)
            updateGender(gender: gender!)
            let ref = Database.database().reference().child("cloths").child(GENDER).queryOrdered(byChild: "tags").queryEqual(toValue: clas)
            self.dismiss(animated: true){
                self.delgate?.filter(query: ref)
            }
        }else if gender == nil && type != nil {
            let clas = getClass(type: type!)
            let ref = Database.database().reference().child("cloths").child(GENDER).queryOrdered(byChild: "tags").queryEqual(toValue: clas)
            self.dismiss(animated: true){
                self.delgate?.filter(query: ref)
            }
        }else if gender != nil && type == nil {
            updateGender(gender: gender!)
            let ref = Database.database().reference().child("cloths").child(GENDER).queryOrdered(byChild: "date")
            self.dismiss(animated: true){
                self.delgate?.filter(query: ref)
            }
        }else {
            SCLAlertView().showError("Error", subTitle: "Please select parameters to filter with or just cancel to return to shop view")
        }
    }
    
    @IBAction func BackBtn(_ sender: Any) {
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
    
    func showPicker(){
        print("ahow picker")
        if pickerType == 0 {
            typePicker.isHidden = true
            genderPicker.isHidden = false
            genderPicker.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(genderPicker)
            
            genderPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            genderPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            genderPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }else {
            typePicker.isHidden = false
            genderPicker.isHidden = true
            typePicker.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(typePicker)
            
            typePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            typePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            typePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == 0 {
            gender = genderList[row]
            GENDER = genderList[row]
            filterText.setTitle(gender, for: .normal)
            genderPicker.endEditing(true)
            genderPicker.isHidden = true
        }else {
            type = typeList[row]
            typeText.setTitle(type, for: .normal)
            typePicker.endEditing(true)
            typePicker.isHidden = true
        }
        //picker.endEditing(true)
        //picker.isHidden = true
        //picker.removeFromSuperview()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == 0 {
            return genderList[row]
        }else{
            return typeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerType == 0 {
            return genderList.count
        }else {
            return typeList.count
        }
    }
    
    func getClass(type: String)-> String {
        switch type {
        case "Casual wears":
            return "casuals"
        case "Corporate wears":
            return "corporate"
        case "Traditional wears":
            return "native"
        case "Shirts":
            return "shirt"
        case "Gown":
            return "gown"
        case "Trousers":
            return "trousers"
        case "Wedding Outfits":
            return "wedding"
        case "Ankara":
            return "ankara"
        case "Suits":
            return "suit"
        default:
            return ""
        }
    }
    
    func updateGender(gender: String){
        GENDER = gender
    }
}

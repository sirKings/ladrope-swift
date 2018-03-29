//
//  SecondViewController.swift
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

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderArray = [Order]()
    var completedOrders = [Order]()
    var pendingOrders = [Order]()
    var savedOrders = [Order]()
    var selectedOrder: Order?
    
    @IBOutlet var orderTableList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getOrders()
        
        
        orderTableList.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: "orderViewCell")
        orderTableList.delegate = self
        orderTableList.dataSource = self
        orderTableList.separatorStyle = .none
        orderTableList.rowHeight = 130
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOrder"{
            let ODVC = segue.destination as! OrderDetailsViewController
            ODVC.order = selectedOrder!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            orderArray = completedOrders
            orderTableList.reloadData()
        case 1:
            orderArray = pendingOrders
            orderTableList.reloadData()
        case 2:
            orderArray = savedOrders
            orderTableList.reloadData()
        default:
            orderArray = completedOrders
            orderTableList.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if orderArray.count == 0 {
            tableView.setEmptyMessage("You currently dont have any orders")
        } else {
            tableView.restore()
        }
        return orderArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableList.dequeueReusableCell(withIdentifier: "orderViewCell", for: indexPath) as! OrderViewCell
        
        let order = orderArray[indexPath.row]
        
        let imgUrl = URL(string: order.image1!)
        cell.orderImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if order.date != nil {
            
        }else{
            order.date = ""
        }
        
        if order.startDate != nil {
            
        }else{
            order.startDate = ""
        }
        
        cell.deliveryDate.text = "Delivery date: \(formatDate(str: order.date!))"
        cell.startDate.text = "Start date: \(formatDate(str: order.startDate!))"
        cell.orderStatus.text = "Status: \(order.status ?? "Pending")"
        cell.orderName.text = order.name?.capitalized
        return cell
    }
    
    func getOrders(){
        getCompletedOrders()
        getPendingOrders()
        getSavedOrders()
    }
    
    func getCompletedOrders(){
        let orderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("completedorders")
        
        orderRef.observe(.childAdded){
            snapshot in
            
            guard let value = snapshot.value else {
                SVProgressHUD.dismiss()
                return
                
            }
            do {
                let cloth = try FirebaseDecoder().decode(Order.self, from: value)
                //print(cloth)
                self.completedOrders.append(cloth)
                SVProgressHUD.dismiss()
                self.orderArray = self.completedOrders
                self.orderTableList.reloadData()
            } catch let error {
                print(error)
                SVProgressHUD.dismiss()
            }
        }
        
        SVProgressHUD.dismiss()
    }
    
    func getSavedOrders(){
        let orderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("savedOrders")
        
        orderRef.observe(.childAdded){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let cloth = try FirebaseDecoder().decode(Order.self, from: value)
                //print(cloth)
                self.savedOrders.append(cloth)
                //SVProgressHUD.dismiss()
                //self.orderArray = self.completedOrders
                //self.orderTableList.reloadData()
            } catch let error {
                print(error)
            }
        }
        
        
    }
    
    func getPendingOrders(){
        let orderRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders")
        pendingOrders.removeAll()
        
        orderRef.observe(.childAdded){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let cloth = try FirebaseDecoder().decode(Order.self, from: value)
                //print(cloth)
                self.pendingOrders.append(cloth)
                //SVProgressHUD.dismiss()
                //self.orderArray = self.completedOrders
                //self.orderTableList.reloadData()
            } catch let error {
                print(error)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem(cloth: orderArray[indexPath.row])
    }
    
    
    func selectItem(cloth: Order) {
        selectedOrder = cloth
        if cloth.status == "Pending"{
            self.performSegue(withIdentifier: "goToOrder", sender: self)
            
        }else if cloth.status == "Completed"{
            SCLAlertView().showInfo("Completed", subTitle: "This order has been completed")
        }else {
            let alert = SCLAlertView()
            alert.addButton("Measure now"){
                self.goToMeasurement()
                
            }
            alert.showInfo("Not Submitted", subTitle: "Please take your measurement now to submit this order.")
        }
    }
    
    func goToMeasurement(){
        self.performSegue(withIdentifier: "goToMeasurement", sender: self)
    }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    
}


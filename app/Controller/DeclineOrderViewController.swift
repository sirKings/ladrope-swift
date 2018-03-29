//
//  DeclineOrderViewController.swift
//  app
//
//  Created by MAC on 3/28/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire


protocol DeclineOrderProtocol {
    func closeOrderDetails()

}

class DeclineOrderViewController: UIViewController {
    
    var order: Order?
    var delegate: DeclineOrderProtocol?
    
    @IBOutlet var reasonText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func declineOrder(_ sender: UIButton) {
        reportDecline()
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
    
    func reportDecline(){
        if reasonText.text == ""{
            SCLAlertView().showError("Error", subTitle: "Please tell us why you are not satisfied")
        }else{
            let parameters = ["orderId": order?.orderId, "Reason": reasonText.text]
            Alamofire.request(DECLINE_ORDER_URL, method: .post, parameters: parameters)
            self.dismiss(animated: true){
                self.delegate?.closeOrderDetails()
            }
        }
    }

}

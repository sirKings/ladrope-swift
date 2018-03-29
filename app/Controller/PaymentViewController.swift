//
//  PaymentViewController.swift
//  app
//
//  Created by MAC on 3/27/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Paystack
import Firebase
import Alamofire
import SVProgressHUD
import SCLAlertView

class PaymentViewController: UIViewController, PSTCKPaymentCardTextFieldDelegate {
    
    var price: Int?
    var cloths: [Cloth]?
    var sender: Bool?
    
    @IBOutlet var amount: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var paymentView: UIView!
    let paymentTextField = PSTCKPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.7)
        paymentTextField.frame = CGRect(x:0, y:10, width: 350, height: 44)
        paymentTextField.delegate = self
        paymentView.addSubview(paymentTextField)
        amount.text = "Total: NGN\(price!).00"
    }
    @IBAction func pay(_ sender: UIButton) {
        
        SVProgressHUD.show()
        submitButton.isEnabled = false
        let cardParams = paymentTextField.cardParams as PSTCKCardParams

        // cardParams already fetched from our view or assembled by you
        let transactionParams = PSTCKTransactionParams.init();

        // building new Paystack Transaction
        transactionParams.amount = UInt(price!)
//        do {
//            try transactionParams.setCustomFieldValue("iOS SDK", displayedAs: "Paid Via");
//            try transactionParams.setCustomFieldValue("Paystack hats", displayedAs: "To Buy");
//            try transactionParams.setMetadataValue("iOS SDK", forKey: "paid_via");
//        } catch {
//            print(error);
//        }
        transactionParams.email = (Auth.auth().currentUser?.email)!

        PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: self,
                                           didEndWithError: { (error, reference) -> Void in
                                            self.handleError(error: error)
        }, didRequestValidation: { (reference) -> Void in
            // an OTP was requested, transaction has not yet succeeded
        }, didTransactionSuccess: { (reference) -> Void in
            // transaction may have succeeded, please verify on backend
            self.verify(ref: reference)
                 })
        //OrderNow(cloths: cloths!, ref: "fake string")
    }
    
    func handleError(error: Error){
        print(error.localizedDescription)
        SCLAlertView().showError("Error", subTitle: error.localizedDescription)
        SVProgressHUD.dismiss()
        submitButton.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paymentCardTextFieldDidChange(_ textField: PSTCKPaymentCardTextField) {
        // Toggle navigation, for example
        submitButton.isEnabled = textField.isValid
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func verify(ref: String) {
        let parameters = ["code": ref, "amount": price! * 100] as [String : Any]
        Alamofire.request(VERIFY_PAYMENT_URL, method: .post, parameters: parameters).response(){
            res in
            if res.error == nil{
                print("Responds",res.data!)
                
                SVProgressHUD.dismiss()
                self.submitButton.isEnabled = true
                
                let resData = String(describing: res.data)
                
                if resData == "OK" {
                    print("data verified", resData)
                    self.OrderNow(cloths: self.cloths!, ref: ref)
                    
                }
            }else{
                SCLAlertView().showError("Error", subTitle: "There was an error verifying your payment")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func OrderNow(cloths: [Cloth], ref: String) {
        
        placeOrders(cloths: cloths, ref: ref){
            status in
            if status {
                if self.sender == true {
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("cart").setValue(nil)
                }
                
              self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}

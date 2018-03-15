//
//  CreateAccountViewController.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SCLAlertView
import GoogleSignIn

class CreateAccountViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var passwordMatch: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        //firebase signin
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        if(email.text! == "" || name.text! == "" || password.text! == "" || passwordMatch.text! == ""){
            SCLAlertView().showError("Error", subTitle: "Please enter all details")
        }else{
            if(!isValidEmail(testStr: email.text!)){
                SCLAlertView().showError("Error", subTitle: "Please enter a valid email")
            }else{
                if(password.text!.count < 6){
                    SCLAlertView().showError("Error", subTitle: "Password maust be atleast six characters")
                }else{
                    if(passwordMatch.text! != password.text!){
                        SCLAlertView().showError("Error", subTitle: "Password must match")
                    }else{
                        SVProgressHUD.show()
                        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: CreateAccountCallBack(user:error:))
                    }
                }
            }
        }
    }
    
    func CreateAccountCallBack(user: User?, error: Error?){
        if(error == nil){
            
            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = name.text!
            changeRequest.commitChanges { (error) in
                // ...
                if error == nil {
                    var myUser = MyUser()
                    myUser.displayName = user?.displayName
                    myUser.email = user?.email
                    myUser.gender = "male"
                    
                    saveUser(user: myUser, uid: user!.uid)
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goHomeFromCreateAccount", sender: self)
                }
            }
            
        }else{
            SVProgressHUD.dismiss()
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                switch errCode {
                case .emailAlreadyInUse:
                    SCLAlertView().showError("Error", subTitle: "Email already in use")
                case .userNotFound:
                    SCLAlertView().showError("Error", subTitle: "User not found, Check the email and try again")
                case .invalidEmail:
                    SCLAlertView().showError("Error", subTitle: "Invalid email address")
                default:
                    SCLAlertView().showError("Error", subTitle: "Oops, something went wrong. Try again")
                }
            }
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            if let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                case .emailAlreadyInUse:
                    SCLAlertView().showError("Error", subTitle: "Email already in use")
                case .userNotFound:
                    SCLAlertView().showError("Error", subTitle: "User not found, Check the email and try again")
                case .invalidEmail:
                    SCLAlertView().showError("Error", subTitle: "Invalid email address")
                default:
                    SCLAlertView().showError("Error", subTitle: "Oops, something went wrong. Try again")
                }
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            SVProgressHUD.show()
            if let error = error {
                // ...
                SVProgressHUD.dismiss()
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        SCLAlertView().showError("Error", subTitle: "Email already in use")
                    case .userNotFound:
                        SCLAlertView().showError("Error", subTitle: "User not found, Check the email and try again")
                    case .invalidEmail:
                        SCLAlertView().showError("Error", subTitle: "Invalid email address")
                    default:
                        SCLAlertView().showError("Error", subTitle: "Oops, something went wrong. Try again")
                    }
                }
                
                return
            }
            // User is signed in
            var myUser = MyUser()
            myUser.email = user!.email
            myUser.displayName = user!.displayName
            myUser.gender = "male"
            myUser.photoURL = String(describing: user?.photoURL)
            
            saveUser(user: myUser, uid: user!.uid)
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goHomeFromCreateAccount", sender: self)
           
        }
    }

}

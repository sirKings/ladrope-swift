//
//  LoginViewController.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
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
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if(email.text! != "" && password.text! != ""){
            if(isValidEmail(testStr: email.text!)){
                SVProgressHUD.show()
                Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: loginCallBack)
            }else{
                SCLAlertView().showError("Error", subTitle: "Please enter a valid email")
            }
        }else{
            SCLAlertView().showError("Error", subTitle: "Please enter all details")
        }
    }
    
    func loginCallBack(user: User?, error: Error?){
        if(error == nil){
            SVProgressHUD.dismiss()
            getUser()
            performSegue(withIdentifier: "goHomeFromLogin", sender: self)
        }else{
            SVProgressHUD.dismiss()
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                switch errCode {
                case .wrongPassword:
                    SCLAlertView().showError("Error", subTitle: "Wrong Password")
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
    //this is an error in assignment, this is forget password buttun call
    @IBAction func loginWithGooglePressed(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        let alert = SCLAlertView(appearance: appearance)
        //let alert = SCLAlertView()
        let txt = alert.addTextField("Enter your email")
        alert.addButton("Reset Password", backgroundColor: UIColor(red: 0, green: 0.3, blue: 0, alpha: 1.0)) {
            if self.isValidEmail(testStr: txt.text!){
                self.sendResetEmail(email: txt.text!)
                alert.dismiss(animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Info", message: "Enter valid email", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
    
        }
        alert.addButton("Cancel", backgroundColor: UIColor(red: 0, green: 0.3, blue: 0, alpha: 1.0)){
            alert.dismiss(animated: true, completion: nil)
            }
        alert.showSuccess("Forget Password?", subTitle: "We will send a reset password link to the email you enter")
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func sendResetEmail(email: String){
            
            Auth.auth().sendPasswordReset(withEmail: email){
               error in
                SVProgressHUD.show()
                
                if error == nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Success", message: "Reset email sent", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    SVProgressHUD.dismiss()
                    // create the alert
                    let alert = UIAlertController(title: "Error", message: "Reset email not sent, Try again later", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        // ...
        if let error = error {
            // ...
            if let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                case .wrongPassword:
                    SCLAlertView().showError("Error", subTitle: "Wrong Password")
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
                    case .wrongPassword:
                        SCLAlertView().showError("Error", subTitle: "Wrong Password")
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
            getUser()
            self.performSegue(withIdentifier: "goHomeFromCreateAccount", sender: self)
        }
    }
}

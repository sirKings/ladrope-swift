//
//  MainViewController.swift
//  app
//
//  Created by MAC on 3/9/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener(){
            (auth, user) in
            if user != nil {
                self.performSegueForMe(identifier: "goHome")
            }else{
                
            }
        }
    }
    
    func performSegueForMe(identifier: String){
        performSegue(withIdentifier: identifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreateAccount", sender: self)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
}

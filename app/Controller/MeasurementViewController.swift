//
//  MeasurementViewController.swift
//  app
//
//  Created by MAC on 3/16/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class MeasurementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func UseCameraPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToStartMeasure", sender: self)
    }
    @IBAction func EnterMeasurement(_ sender: Any) {
        performSegue(withIdentifier: "goToEnterMeasurement", sender: self)
    }

}

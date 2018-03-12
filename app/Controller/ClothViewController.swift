//
//  ClothViewController.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class ClothViewController: UIViewController {
    
    var cloth: Cloth?
    
    @IBOutlet weak var titleBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(cloth?.clothKey!)
        titleBar.title = cloth?.name!
        
    }

    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

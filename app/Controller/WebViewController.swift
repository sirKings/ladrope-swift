//
//  WebViewController.swift
//  app
//
//  Created by MAC on 3/17/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var link: String?
    
    @IBOutlet weak var ladWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Disable navigation buttons on first loads
        
        let url = URL(string: link!)
        let request = URLRequest(url: url!)
        
        ladWebView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

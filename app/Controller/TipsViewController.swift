//
//  TipsViewController.swift
//  app
//
//  Created by MAC on 3/16/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TipsViewController: UIViewController {
    
    var videoPlayed = false
    let avplayerController = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(videoPlayed){
            
        }else{
            playVideo(from: "measurement.mp4")
            videoPlayed = true
        }
        
    }
    
    private func playVideo(from file:String) {
        let file = file.components(separatedBy: ".")
        
        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func RewatchVideo(_ sender: Any) {
        playVideo(from: "measurement.mp4")
    }
    
    @IBAction func MeasureNow(_ sender: Any) {
        performSegue(withIdentifier: "startMeasure", sender: self)
    }
    
    @IBAction func RemindLater(_ sender: Any) {
        performSegue(withIdentifier: "showPopOver", sender: self)
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

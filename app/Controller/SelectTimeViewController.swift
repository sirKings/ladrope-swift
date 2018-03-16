//
//  SelectTimeViewController.swift
//  app
//
//  Created by MAC on 3/16/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import UserNotifications
import SCLAlertView


class SelectTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func oneHour(_ sender: Any) {
        checkPermission(inSeconds: 60*60*60)
    }
    
    @IBAction func twoHours(_ sender: Any) {
        checkPermission(inSeconds: 60*60*60*2)
    }
    @IBOutlet weak var sixHours: UIButton!
    
    @IBAction func sixHours(_ sender: Any) {
        checkPermission(inSeconds: 60*60*60*6)
    }
    
    @IBAction func twelveHours(_ sender: Any) {
        checkPermission(inSeconds: 60*60*60*12)
    }
    @IBAction func tomorrow(_ sender: Any) {
        checkPermission(inSeconds: 60*60*60*24)
    }
    
    func scheduleNotification(inSeconds : TimeInterval){
        let notif = UNMutableNotificationContent()
        notif.title = "New notification"
        notif.subtitle = "Time to get measured!"
        notif.body = "Take your measurement and start making better fashion choices on ladrope"
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "myNotification", content:  notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print(error!)
                //completion(false)
            }else{
                //completion(true)
                self.dismiss(animated: true){
                    SCLAlertView().showSuccess("Success", subTitle: "A notification has been set for you to remind you when to take your measurement")
                }
            }
        }
    }
    
    func checkPermission(inSeconds: TimeInterval){
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleNotification(inSeconds: inSeconds)
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleNotification(inSeconds: inSeconds)
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
}

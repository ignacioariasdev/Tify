//
//  NotificationViewController.swift
//  WorkoutNotificationContentExtension
//
//  Created by Ignacio Arias on 2020-07-26.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentSubtitle: UILabel!
    @IBOutlet weak var contentBody: UILabel!
    @IBOutlet weak var contentImageview: UIImageView!
    
    
    @IBAction func snoozeButton(_ sender: UIButton) {
        
//        let content = changeWorkoutNotifications(content: request.content)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
//            self.printError(error, location: "Snooze Action")
        }
        
        extensionContext?.dismissNotificationContentExtension()
    }
    
    
    @IBAction func likeButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Like" {
            sender.setTitle("Unlike", for: .normal)
            extensionContext?.notificationActions = [snoozeAction, unlikeAction]
        } else {
            sender.setTitle("Like", for: .normal)
            extensionContext?.notificationActions = [snoozeAction, likeAction]
        }
    }
    
    
    
    var content = UNMutableNotificationContent()
    var requestIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    let unlikeAction = UNNotificationAction(identifier: "unlike", title: "unLike", options: [])
    let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
    let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze 5 seconds", options: [])
    
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        let action = response.actionIdentifier
        
        if action == "like" {
            extensionContext?.notificationActions = [snoozeAction, unlikeAction]
        }
        
        if action == "unlike" {
            extensionContext?.notificationActions = [snoozeAction, likeAction]
        }
        
        if action == "snooze" {
            completion(.dismissAndForwardAction)
        }
        
        completion(.doNotDismiss)
    }
    
    func didReceive(_ notification: UNNotification) {
        
        requestIdentifier = notification.request.identifier
        
        
        content = notification.request.content.mutableCopy() as! UNMutableNotificationContent
        
        contentTitle.text = content.title
        contentSubtitle.text = content.subtitle
        contentBody.text = content.body
        
        extensionContext?.notificationActions = [snoozeAction, likeAction]
    }
    
}

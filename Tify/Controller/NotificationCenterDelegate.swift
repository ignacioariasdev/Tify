//
//  NotificationCenterDelegate.swift
//  Tify
//
//  Created by Ignacio Arias on 2020-07-20.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    //With this notifications can appear in other or same view (all view controllers)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        let content = request.content.mutableCopy() as! UNMutableNotificationContent
        
        if action == "text.action" {
            let textResponse = response as! UNTextInputNotificationResponse
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            
            newContent.subtitle = textResponse.userText
            
            let request = UNNotificationRequest(identifier: request.identifier, content: newContent, trigger: request.trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                self.printError(error, location: "Text Input action")
            }
        }
        
        if action == "cancel" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
        }
        
        if action == "snooze" {
            
            let content = changeWorkoutNotifications(content: request.content)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                self.printError(error, location: "Snooze Action")
            }
        }
        
        if action == "next.step" {
            guard var step = content.userInfo["step"] as? Int else {return}
            step += 1
            if step < workoutSteps.count {
                content.body = workoutSteps[step]
                content.userInfo["step"] = step
                
                let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    self.printError(error, location: "Next Step action")
                }
            } else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        }
        completionHandler()
    }
   
    func changeWorkoutNotifications(content oldContent: UNNotificationContent) -> UNMutableNotificationContent {
        
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        
        let userInfo = content.userInfo as! [String: Any]
        
        if let orders = userInfo["order"] as? [String] {
            
            content.body = "You are going to love this:\n"
            
            for item in orders {
                content.body += surferBullet + item + "\n"
            }
        }
        return content
    }
    

    
    
    
    
    
    //MARK: - Support Methods
    let surferBullet = "🏄🏽‍♀️ "
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
}

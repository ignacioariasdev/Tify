//
//  NotificationService.swift
//  WorkoutNotificationServiceExtension
//
//  Created by Ignacio Arias on 2020-07-26.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [Push]"
            
            
            switch bestAttemptContent.categoryIdentifier {
                
            case "snooze.category":
                let newContent = changeWorkoutNotifications(content: request.content)
                
                //This is the attachment to fast read that resource .GIF
//                  let imageURL = URL(fileReferenceLiteralResourceName: "goku.gif")
//                  
//                  //Ctrl click on UNNotificationAttachment go to documentation to have a better reference on sizes & types
//                  let attachment = try! UNNotificationAttachment(identifier: "animation.goku.gif", url: imageURL, options: nil)
//                  
//                  newContent.attachments = [attachment]
                
                
                newContent.title = newContent.title + "[Push]"
                contentHandler(newContent)
            
            default:
                contentHandler(bestAttemptContent)
            }
            
            contentHandler(bestAttemptContent)
        }
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
    
    //Short time to get content IN
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
            
            bestAttemptContent.title = bestAttemptContent.title + "[Late]"
            contentHandler(bestAttemptContent)
        }
    }

}

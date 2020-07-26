//
//  AppDelegate.swift
//  Tify
//
//  Created by Ignacio Arias on 2020-07-20.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    let ncDelegate = NotificationCenterDelegate()
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(tokenString(deviceToken))
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printError(error, location: "Remote Notification registration")
    }
       
       func setCategories() {
           
           //Actions
           let nextStepAction = UNNotificationAction(identifier: "next.step", title: "Next", options: [])
           let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Title", options: [])
           
           //Red label .destructive (makes the user think twice before clicked
           let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel Workout", options: [.destructive])
           
           let textInputAction = UNTextInputNotificationAction(identifier: "text.input", title: "Comments", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Comments here please")
           
           //Categories
           
           //"actual actions array that will show up (in that order)"
           let workoutStepsCategory = UNNotificationCategory(identifier: "workout.steps.category", actions: [nextStepAction, snoozeAction, textInputAction, cancelAction], intentIdentifiers: [], options: [])
           
           let snoozeStepsCategory = UNNotificationCategory(identifier: "snooze.steps.category", actions: [snoozeAction], intentIdentifiers: [], options: [])
           
           UNUserNotificationCenter.current().setNotificationCategories([workoutStepsCategory, snoozeStepsCategory])
       }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Keep in mind the .provisional to ask the user if he wants to keep reciving or not. pros good ux, cons: not dd
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            self.printError(error, location: "Request Authorization")
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        //With this notifications can appear in other or same view (all view controllers)
        UNUserNotificationCenter.current().delegate = ncDelegate
        
        setCategories()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
   //MARK: - Support Methods
           
           // A function to print errors to the console
           func printError(_ error:Error?,location:String){
               if let error = error{
                   print("Error: \(error.localizedDescription) in \(location)")
               }
           }
    
    func tokenString(_ deviceToken: Data) -> String {
        //Code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes {
            token += String(format: "%02x", byte)
        }
        return token
    }


}


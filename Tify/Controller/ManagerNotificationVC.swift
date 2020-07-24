//
//  ManagerNotificationVC.swift
//  Tify
//
//  Created by Ignacio Arias on 2020-07-21.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import UserNotifications

class ManageNotificationsViewController: UIViewController{
    
    @IBOutlet weak var pendingNotificationButton: UIButton!
    @IBOutlet weak var consoleView: UITextView!
    
//    let workoutSteps = ["Warmup", "stretch", "Legs", "core", "15 cardio"]
    
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //Different identifiers will count as a different request
    @IBAction func viewPendingNotifications(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            self.printRequest(count: requests.count, type: "Pending")
            
            for request in requests {
                
                self.printConsoleView("\(request.identifier):\(request.content.body)\n")
            }
        }
    }
    
    @IBAction func viewDeliveredNotifications(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            
            self.printRequest(count: notifications.count, type: "Delivered")
            
            for notification in notifications {
                
                self.printConsoleView("\(notification.request.identifier):\(notification.request.content.body)\n")
                
            }
        }
    }
    
    @IBAction func removeAllNotifications(_ sender: UITapGestureRecognizer) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    @IBAction func removeNotification(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            if let request = requests.first(where: { (request) -> Bool in
                request.trigger?.repeats == true
            }) {
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                
            }
            
            
            
        }
        
    }
    
    @IBAction func nextPlanStep(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            for request in requests {
                if request.identifier.hasPrefix("message.workout") {
                    
                    guard let content = self.updatePlanContent(request: request) else {
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        return
                    }
                    
                    self.addNotification(trigger: request.trigger, content: content, identifier: request.identifier)
                    
                    return
                }
            }
            
        }
        
    }
    
    
    func updatePlanContent(request: UNNotificationRequest) -> UNMutableNotificationContent! {
        
        if let stepNumber = request.content.userInfo["step"] as? Int {
            
            let newStepNumber = (stepNumber + 1)
            
            let updatedContent = request.content.mutableCopy() as! UNMutableNotificationContent
            
            if newStepNumber >= workoutSteps.count { return nil}
            
            if newStepNumber == workoutSteps.count - 1 {
                updatedContent.threadIdentifier = request.identifier
                updatedContent.categoryIdentifier = "snooze.category"
            }
            
            updatedContent.body = workoutSteps[newStepNumber]
            updatedContent.userInfo["step"] = newStepNumber
            
            
            return updatedContent
        }
        return request.content as? UNMutableNotificationContent
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLayoutSubviews() {
        // rouds to corners of the console view
        consoleView.layer.cornerRadius = consoleView.frame.height * 0.05
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    //MARK: - Support Methods
    func printConsoleView(_ string:String){
        DispatchQueue.main.async {
            self.consoleView.text += string
        }
    }
    func clearConsoleView(){
        DispatchQueue.main.async {
            self.consoleView.text = ""
        }
    }
    
    //a function to nicely print the date, count and type of notification.
    func printRequest(count:Int, type:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: Date())
        var countString = String(format: "%i",count)
        countString = dateString + "---->" + countString + " requests " + type + "\n"
        clearConsoleView()
        printConsoleView(countString)
    }
    
    func notificationContent(title:String,body:String)->UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = ["step":0]
        return content
    }
    func addNotification(trigger:UNNotificationTrigger?,content:UNMutableNotificationContent,identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add Request for Identifier:" + identifier)
        }
    }
    
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
}

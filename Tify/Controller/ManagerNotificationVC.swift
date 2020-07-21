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
    
    let burnFatSteps = ["No salt", "No sugar", "No saturated fat", "stick to water"]
    
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //Different identifiers will count as a different request
    @IBAction func viewPendingNotifications(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            self.printRequest(count: requests.count, type: "Pending")
            
            for request in requests {
                
                self.printConsoleView("\(request.identifier)\(request.content.body)\n\(request.content.title)")
            }
        }
    }
    
    @IBAction func viewDeliveredNotifications(_ sender: UIButton) {
       
    }
    
    @IBAction func removeAllNotifications(_ sender: UITapGestureRecognizer) {
       
    }
    
    @IBAction func removeNotification(_ sender: UIButton) {
        
    }
    
    @IBAction func nextPlanStep(_ sender: UIButton) {
        
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

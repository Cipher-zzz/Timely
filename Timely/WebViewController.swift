//
//  WebViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/4.
//  Copyright © 2019 monash. All rights reserved.
//
// https://benoitpasquier.com/ios-and-javascript/
// https://developer.apple.com/documentation/webkit/wkwebview
// https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview
// https://developer.apple.com/documentation/foundation/nsdictionary
// String iteratation: https://medium.com/@nikhilpatil/loop-string-characters-with-index-in-swift-4-0-cc050c88af5f

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var user_inf : [String: UnitData] = [:]
    var webView: WKWebView!
    weak var databaseController: DatabaseProtocol?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // let myURL = URL(string:"https://monashuni.okta.com/app/monashuniversity_allocateplus_1/exk1lqfohscjojl1p2p7/sso/saml")
        let myURL = URL(string:"https://my-timetable.monash.edu/odd/student?ss=503350ab070d40fea4fe311f690e7e39")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        displayMessage(title: "Instruction", message: "Please login in your monash account first, after you see the allocate+ page, click sync button", pop: false)
        
    }
    
    @IBAction func syncButton(_ sender: Any) {
        webView.evaluateJavaScript("JSON.stringify(data.student)"){(data,error) in
            if let data = data as? String {
                do {
                    let decoder = JSONDecoder()
                    //print(data)
                    let volumeData = try decoder.decode(VolumeData.self, from: data.data(using: .utf8)!)
                    self.user_inf = volumeData.units!
                    
                    
                    for item in self.user_inf{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

                        
                        var currentStartDate = dateFormatter.date(from: "\(item.value.startDate!) \(item.value.startTime!)")
                        var currentEndDate = currentStartDate?.add(component: .minute, value: Int(item.value.duration!)!)
                        let currentDayOfWeek =  item.value.dayOfWeek
                        
                        if currentDayOfWeek == "Tue"{
                            currentStartDate = currentStartDate!.add(component: .day, value: 1)
                            currentEndDate = currentEndDate!.add(component: .day, value: 1)
                        }
                        else if currentDayOfWeek == "Wed"{
                            currentStartDate = currentStartDate!.add(component: .day, value: 2)
                            currentEndDate = currentEndDate!.add(component: .day, value: 2)
                        }
                        else if currentDayOfWeek == "Thu"{
                            currentStartDate = currentStartDate!.add(component: .day, value: 3)
                            currentEndDate = currentEndDate!.add(component: .day, value: 3)
                        }
                        else if currentDayOfWeek == "Fri"{
                            currentStartDate = currentStartDate!.add(component: .day, value: 4)
                            currentEndDate = currentEndDate!.add(component: .day, value: 4)
                        }
                        
                        let currentWeekPattern = item.value.weekPattern
                        for i in 0..<currentWeekPattern.count {
                            let index = currentWeekPattern.index(currentWeekPattern.startIndex, offsetBy: i)
                            if currentWeekPattern[index] == "1"{
                                let _ = self.databaseController?.addTask(newTaskTitle: item.key, newTaskDescription: "Unit: \(item.value.subjectTitle!) Staff is \(item.value.staff!)", newTaskDueDate: currentEndDate!, newTaskStartDate: currentStartDate!, newTaskAddress: item.value.location!, newTaskRepeat: false, newTaskHasBeenCompleted: false)
                            }
                            currentStartDate = currentStartDate!.add(component: .day, value: 7)
                            currentEndDate = currentEndDate!.add(component: .day, value: 7)
                        }
                    }
                    self.displayMessage(title: "Success", message: "your courses have been added successfully", pop: true)
                } catch let error {
                    //self.webView.reload()
                    //self.webView.goBack()
                    print("JSONDecoderError:\(error)")
                    self.displayMessage(title: "Error", message: "Sorry about that, Monash has updated the allocate plus system. I will fix it as soon as possiable", pop: true)
                }
            }
            else {
                print("evaluateJavaScriptError")
                self.displayMessage(title: "Error", message: "Please try again, only click the sync button when you login in successfully and it shows allocate+ page", pop: false)
            }
        }
    }
    
    func popHandler(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    func displayMessage(title: String, message: String, pop: Bool) {
        // Setup an alert to show user details about the Person
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        // If use input correctly, the feedback will lead to the page before,
        // else if user get an error, it should stay in current page.
        // Writing handler for UIAlertAction: https://stackoverflow.com/questions/24190277/writing-handler-for-uialertaction
        
        if pop{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: popHandler))
        }
        else{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

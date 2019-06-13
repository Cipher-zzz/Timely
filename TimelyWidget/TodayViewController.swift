//
//  TodayViewController.swift
//  TimelyWidget
//
//  Created by 张泽正 on 2019/6/13.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sharedDefaults = UserDefaults.init(suiteName: "group.Cipher.Timely")
        widgetLabel.text = "\(sharedDefaults?.value(forKey: "taskTitle") ?? "Please open Timely")"
        
        // Set the color of cell
        if widgetLabel.text!.contains("LABORATORY") || widgetLabel.text!.contains("WORKSHOP"){
            widgetLabel.textColor = UIColor(hex: 0xFFD700)   // Contain color
        }
        else if widgetLabel.text!.contains("LECTURE") || widgetLabel.text!.contains("SEMINAR"){
            widgetLabel.textColor = UIColor(hex: 0x0899FF)   // Contain color
        }
        else if widgetLabel.text!.contains("TUTORIAL"){
            widgetLabel.textColor = UIColor(hex: 0x00FF7F)   // Contain color
        }
        else{
            widgetLabel.textColor = UIColor(hex: 0xFF69B4)   // Contain color
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    //Get UIColor by hex
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}

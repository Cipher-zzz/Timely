//
//  EventCell.swift
//  Timely
//  Copy from framework by Jeff Zhang on 3/4/18.
//  Created by 张泽正 on 2019/5/18.
//  Copyright © 2019 monash. All rights reserved.
// https://www.youtube.com/watch?v=c5blPI3Asmw

import UIKit
import JZCalendarWeekView

// If you want to use Move Type LongPressWeekView, you have to inherit from JZLongPressEventCell and update event when you configure cell every time
class EventCell: JZLongPressEventCell {
    
    var task: Task?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasic()
        // You have to set the background color in contentView instead of cell background color, because cell reuse problems in collectionview
        // When setting alpha to cell, the alpha will back to 1 when collectionview scrolled, which means that moving cell will not be translucent
        self.contentView.backgroundColor = UIColor(hex: 0xFF69B4)
        
//        let recogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.contentView.addGestureRecognizer(recogniser)
    }
    
//    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
//        print("tapped \(titleLabel.text!)")
//        let currentEvent = self.event as! AllDayEvent
//                
//    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        borderView.backgroundColor = UIColor(hex: 0xFF1493)
    }
    
    func configureCell(event: AllDayEvent, isAllDay: Bool = false) {
        self.event = event
        locationLabel.text = event.location
        if event.title.count>30 {
            titleLabel.text = String(event.title.prefix(7))
        }
        else{
            titleLabel.text = event.title
        }
        
        // Set the color of cell
        let currentTitle = event.title.lowercased()
        if currentTitle.contains("laboratory") || currentTitle.contains("workshop") || currentTitle.contains("applied_class"){
            self.borderView.backgroundColor = UIColor(hex: 0xDAA520)    //  Side color
            self.contentView.backgroundColor = UIColor(hex: 0xFFD700)   // Contain color
        }
        else if currentTitle.contains("lecture") || currentTitle.contains("seminar"){
            self.borderView.backgroundColor = UIColor(hex: 0x0899FF)    //  Side color
            self.contentView.backgroundColor = UIColor(hex: 0xEEF7FF)   // Contain color
        }
        else if currentTitle.contains("tutorial"){
            self.borderView.backgroundColor = UIColor(hex: 0x00FF00)    //  Side color
            self.contentView.backgroundColor = UIColor(hex: 0x00FF7F)   // Contain color
        }
        else{
            self.borderView.backgroundColor = UIColor(hex: 0xFF1493)    //  Side color
            self.contentView.backgroundColor = UIColor(hex: 0xFF69B4)   // Contain color
        }
        
        locationLabel.isHidden = isAllDay
    }
    
}

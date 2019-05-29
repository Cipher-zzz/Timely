//
//  EventCell.swift
//  Timely
//  Copy from framework by Jeff Zhang on 3/4/18.
//  Created by 张泽正 on 2019/5/18.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import JZCalendarWeekView

// If you want to use Move Type LongPressWeekView, you have to inherit from JZLongPressEventCell and update event when you configure cell every time
class EventCell: JZLongPressEventCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasic()
        // You have to set the background color in contentView instead of cell background color, because cell reuse problems in collectionview
        // When setting alpha to cell, the alpha will back to 1 when collectionview scrolled, which means that moving cell will not be translucent
        self.contentView.backgroundColor = UIColor(hex: 0xFF69B4)
        
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.contentView.addGestureRecognizer(recogniser)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print("tapped \(titleLabel.text!)")
        
    }
    
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
        titleLabel.text = event.title
        if event.title.contains("LABORATORY") || event.title.contains("WORKSHOP"){
            self.borderView.backgroundColor = UIColor(hex: 0xDAA520)    //  Side
            self.contentView.backgroundColor = UIColor(hex: 0xFFD700)   // Contain
        }
        else if event.title.contains("LECTURE") || event.title.contains("SEMINAR"){
            self.borderView.backgroundColor = UIColor(hex: 0x0899FF)    //  Side
            self.contentView.backgroundColor = UIColor(hex: 0xEEF7FF)   // Contain
        }
        else if event.title.contains("TUTORIAL"){
            self.borderView.backgroundColor = UIColor(hex: 0x00FF00)    //  Side
            self.contentView.backgroundColor = UIColor(hex: 0x00FF7F)   // Contain
        }
        else{
            self.contentView.backgroundColor = UIColor(hex: 0xFF69B4)
            self.borderView.backgroundColor = UIColor(hex: 0xFF1493)
        }
        
        locationLabel.isHidden = isAllDay
    }
    
}

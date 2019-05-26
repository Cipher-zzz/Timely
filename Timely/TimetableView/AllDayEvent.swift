//
//  Event.swift
//  Timely
//  Copy from framework by Jeff Zhang on 3/4/18.
//  Created by 张泽正 on 2019/5/17.
//  Copyright © 2019 monash. All rights reserved.
//
import Foundation
import JZCalendarWeekView

class AllDayEvent: JZAllDayEvent {
    
    var location: String
    var title: String
    
    
    init(id: String, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool) {
        self.location = location
        self.title = title
        
        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, isAllDay: isAllDay)
    }
    
    override func copy(with zone: NSZone?) -> Any {
        return AllDayEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay)
    }
}

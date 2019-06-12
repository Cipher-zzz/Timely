//
//  AllDayViewModel.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/17.
//  Copyright © 2019 monash. All rights reserved.
//

import Foundation

import JZCalendarWeekView

class ViewModel: NSObject{
    
    /*
    AllDayEvent(id: "4", title: "AllDay1", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Gold Coast", isAllDay: true),
    AllDayEvent(id: "5", title: "AllDay2", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Adelaide", isAllDay: true),
    AllDayEvent(id: "6", title: "AllDay3", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Cairns", isAllDay: true),
    AllDayEvent(id: "7", title: "AllDay4", startDate: thirdDate.startOfDay, endDate: thirdDate.startOfDay, location: "Brisbane", isAllDay: true)*/
    
    var events = [AllDayEvent(id: "0", title: "One", startDate: Date(), endDate: Date().add(component: .hour, value: 1), location: "Melbourne", isAllDay: false)]
    // var tasks: [Task] = []
    
    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
    
    var currentSelectedData: OptionsSelectedData!
    
    func eventGenerater(taskList:[Task]) -> [AllDayEvent] {
        events = []
        for task in taskList{
            events.append(AllDayEvent(id: UUID().uuidString, title: task.taskTitle!, startDate: task.taskStartDate! as Date, endDate: task.taskDueDate! as Date, location: task.taskAddress!, isAllDay: false, task: task))
        }
        print("events list has been added")
        return events
    }
}



enum ViewType: String {
    case defaultView = "Default JZBaseWeekView"
    case customView = "Custom JZBaseWeekView"
    case longPressView = "JZLongPressWeekView"
}

struct OptionsSelectedData {
    
    var viewType: ViewType
    var date: Date
    var numOfDays: Int
    var scrollType: JZScrollType
    var firstDayOfWeek: DayOfWeek?
    var hourGridDivision: JZHourGridDivision
    var scrollableRange: (startDate: Date?, endDate: Date?)
    
    init(viewType: ViewType, date: Date, numOfDays: Int, scrollType: JZScrollType, firstDayOfWeek: DayOfWeek?, hourGridDivision: JZHourGridDivision, scrollableRange: (Date?, Date?)) {
        self.viewType = viewType
        self.date = date
        self.numOfDays = numOfDays
        self.scrollType = scrollType
        self.firstDayOfWeek = firstDayOfWeek
        self.hourGridDivision = hourGridDivision
        self.scrollableRange = scrollableRange
    }
}

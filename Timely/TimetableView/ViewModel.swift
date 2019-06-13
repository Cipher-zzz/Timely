//
//  AllDayViewModel.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/17.
//  Copyright © 2019 monash. All rights reserved.
//
// This Class store the events data.

import Foundation

import JZCalendarWeekView

class ViewModel: NSObject{
    
    var events = [AllDayEvent(id: "0", title: "One", startDate: Date(), endDate: Date().add(component: .hour, value: 1), location: "Melbourne", isAllDay: false)]
    
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

// From JZiOSFramework
// Have not been used, but save for future usage here.
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

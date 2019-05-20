//
//  AllDayViewModel.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/17.
//  Copyright © 2019 monash. All rights reserved.
//

import Foundation

import JZCalendarWeekView

class ViewModel: NSObject {
    
    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
    lazy var events = [AllDayEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 1), location: "Melbourne", isAllDay: false),
                       AllDayEvent(id: "1", title: "Two", startDate: secondDate, endDate: secondDate.add(component: .hour, value: 4), location: "Sydney", isAllDay: false),
                       AllDayEvent(id: "2", title: "Three", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 2), location: "Tasmania", isAllDay: false),
                       AllDayEvent(id: "3", title: "Four", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 26), location: "Canberra", isAllDay: false),
                       AllDayEvent(id: "4", title: "AllDay1", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Gold Coast", isAllDay: true),
                       AllDayEvent(id: "5", title: "AllDay2", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Adelaide", isAllDay: true),
                       AllDayEvent(id: "6", title: "AllDay3", startDate: firstDate.startOfDay, endDate: firstDate.startOfDay, location: "Cairns", isAllDay: true),
                       AllDayEvent(id: "7", title: "AllDay4", startDate: thirdDate.startOfDay, endDate: thirdDate.startOfDay, location: "Brisbane", isAllDay: true)]
    
    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
    
    var currentSelectedData: OptionsSelectedData!
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

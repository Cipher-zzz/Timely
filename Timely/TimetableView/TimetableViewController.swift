//
//  TimetableViewController.swift
//  Timely
//  Copy from framework by Jeff Zhang on 3/4/18.
//  Created by 张泽正 on 2019/5/4.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class TimetableViewController: UIViewController, DatabaseListener {
    var listenerType = ListenerType.tasks
    
    @IBOutlet weak var calendarWeekView: TimetableWeekView!
    let viewModel = ViewModel()
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarWeekView.viewController = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        setupCalendarView()
    }
    
    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }
    
    private func setupCalendarView() {
        calendarWeekView.baseDelegate = self
        databaseController?.addListener(listener: self)
        
        if viewModel.currentSelectedData != nil {
            setupCalendarViewWithSelectedData() // For the future setting function, the SelectedData is a setting log, contains all the attributes of setupCalendar()
        }
        else {
            calendarWeekView.setupCalendar(numOfDays: 7,
                                           setDate: Date(),
                                           allEvents: viewModel.eventsByDate,
                                           scrollType: .sectionScroll,
                                           scrollableRange: (nil, nil))
        }
        
        // LongPress delegate, datasorce and type setup
        calendarWeekView.longPressDelegate = self
        calendarWeekView.longPressDataSource = self
        calendarWeekView.longPressTypes = [.addNew, .move]
        
        // Optional
        calendarWeekView.addNewDurationMins = 120
        calendarWeekView.moveTimeMinInterval = 15
    }
    
    // For the future setting function, the SelectedData is a setting log, contains all the attributes of setupCalendar()
    private func setupCalendarViewWithSelectedData() {
        guard let selectedData = viewModel.currentSelectedData else { return }
        calendarWeekView.setupCalendar(numOfDays: selectedData.numOfDays,
                                       setDate: selectedData.date,
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: selectedData.scrollType,
                                       firstDayOfWeek: selectedData.firstDayOfWeek)
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send this view controller to setting view controller.
        if segue.identifier == "settingPageSegue" {
            let destination = segue.destination as! SettingPageTableViewController
            destination.viewController = self
        }
    }
    
    // DatabaseListener function, if the tasks been modified, events in viewModel will reload.
    func taskListChange(change: DatabaseChange, tasks: [Task]) {
        viewModel.events = viewModel.eventGenerater(taskList: tasks)
        calendarWeekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
}

// Using extension structure to make it clear that, which functions belong to which delegates
extension TimetableViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        //updateNaviBarTitle()
    }
}

// LongPress core
extension TimetableViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
    
    func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
        // Long press to add new task
        let _ = databaseController!.addTask(newTaskTitle: "newTask", newTaskDescription: "Null", newTaskDueDate: startDate.add(component: .hour, value: weekView.addNewDurationMins/60), newTaskStartDate: startDate, newTaskAddress: "Null", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        weekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
    
    func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
        // Long press a cell, set it to a new time zone.
        let event = editingEvent as! AllDayEvent
        let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
        let currentTask = event.task!
        databaseController!.setTaskDate(settingTask: currentTask, newTaskDueDate: startDate.add(component: .minute, value: duration), newTaskStartDate: startDate)
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
    
    // From JZiOSFramework
    // Have not been used, but save for future usage here.
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
        view.titleLabel.text = "New Event"
        return view
    }
}

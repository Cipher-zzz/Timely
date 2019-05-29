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
    // TODO: reload the view when back from tasks list
    var listenerType = ListenerType.tasks
    
    func taskListChange(change: DatabaseChange, tasks: [Task]) {
        viewModel.events = viewModel.eventGenerater(taskList: tasks)
        viewModel.tasks = tasks
        calendarWeekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
    
    
    @IBOutlet weak var calendarWeekView: JZLongPressWeekView!
    let viewModel = ViewModel()
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            // For example only
            setupCalendarViewWithSelectedData()
        } else {
            calendarWeekView.setupCalendar(numOfDays: 7,
                                           setDate: Date(),
                                           allEvents: viewModel.eventsByDate,
                                           scrollType: .pageScroll,
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
    
    /// For example only
    private func setupCalendarViewWithSelectedData() {
        guard let selectedData = viewModel.currentSelectedData else { return }
        calendarWeekView.setupCalendar(numOfDays: selectedData.numOfDays,
                                       setDate: selectedData.date,
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: selectedData.scrollType,
                                       firstDayOfWeek: selectedData.firstDayOfWeek)
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
    }
}

extension TimetableViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        //updateNaviBarTitle()
    }
}

// LongPress core
extension TimetableViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
    
    func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
        let _ = databaseController!.addTask(newTaskTitle: "newTask", newTaskDescription: "Null", newTaskDueDate: startDate.add(component: .hour, value: weekView.addNewDurationMins/60), newTaskStartDate: startDate, newTaskAddress: "Null", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        weekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
    
    func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
        let event = editingEvent as! AllDayEvent
        let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
        let selectedIndex = viewModel.events.index(where: { $0.id == event.id })!
        let currentTask = viewModel.tasks[selectedIndex]
        //viewModel.events[selectedIndex].startDate = startDate
        //viewModel.events[selectedIndex].endDate = startDate.add(component: .minute, value: duration)
        databaseController!.setTaskDate(settingTask: currentTask, newTaskDueDate: startDate.add(component: .minute, value: duration), newTaskStartDate: startDate)
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events))
    }
    
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
        view.titleLabel.text = "New Event"
        return view
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

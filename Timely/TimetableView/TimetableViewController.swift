//
//  TimetableViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/4.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class TimetableViewController: UIViewController {
    
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
        //let _ = databaseController!.addTask(newTaskTitle: "newTask", newTaskDescription: "Null", newTaskDueDate: startDate.add(component: .hour, value: weekView.addNewDurationMins/60), newTaskStartDate: startDate, newTaskAddress: "Null", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        // TODO: add event
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
    }
    
    func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
        let event = editingEvent as! AllDayEvent
        let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
        let selectedIndex = viewModel.events.index(where: { $0.id == event.id })!
        viewModel.events[selectedIndex].startDate = startDate
        viewModel.events[selectedIndex].endDate = startDate.add(component: .minute, value: duration)
        
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
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

//
//  SettingPageTableViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/6/13.
//  Copyright © 2019 monash. All rights reserved.
// Picker: https://www.youtube.com/watch?v=HkDDGfMiuOA and https://stackoverflow.com/questions/31728680/how-to-make-an-uipickerview-with-a-done-button

import UIKit

class SettingPageTableViewController: UITableViewController {
    
    var viewController: TimetableViewController?
    private var picker: UIPickerView?
    
    @IBOutlet weak var numOfDaysTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numOfDaysTextField.text = String(viewController!.calendarWeekView.numOfDays)
        
        picker = UIPickerView()
        picker?.delegate = self
        picker?.dataSource = self
        
        numOfDaysTextField.inputView = picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SettingPageTableViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        numOfDaysTextField.inputAccessoryView = toolBar
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @objc func doneClick() {
        numOfDaysTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        numOfDaysTextField.resignFirstResponder()
    }
}

// UIPickerViewDelegate and UIPickerViewDataSource delegate for picker.
extension SettingPageTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    // Index start from 0, options start from 1.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    // If selected:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numOfDaysTextField.text = String(row + 1)
        viewController?.calendarWeekView.numOfDays = row + 1
        // Refresh the timetable after setting.
        viewController?.calendarWeekView.refreshWeekView()
    }
}

// TODO: ScrollType setting

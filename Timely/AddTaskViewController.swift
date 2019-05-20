//
//  AddTaskViewController.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/13.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // connect it to the database
    weak var databaseController: DatabaseProtocol?
    // If the segue is editTaskSegue(Edit buttom of detail page)
    // that task object will be store here.
    // If the segue is addTaskSegue, then task will be nil
    var task: Task?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var taskHasBeenCompletedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskRepeatSegmentedControl: UISegmentedControl!
    @IBAction func cancel(_ sender: Any) {
        // Do nothing and pop to the page before.
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // Save the task(or update the exist task)
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if task == nil{
            // Which means that it is creating a new task now!
            if taskTitleTextField.text != "" && dueDateTextField.text != "" && descriptionTextField.text != ""{
                let taskTitle = taskTitleTextField.text!
                let taskStartDate = dateFormatter.date(from: startDateTextField.text!)
                let taskDueDate = dateFormatter.date(from: dueDateTextField.text!)
                let taskAddress = addressTextField.text!
                let taskDescription = descriptionTextField.text!
                
                // Create a new task by the input in core data
                if taskHasBeenCompletedSegmentedControl.selectedSegmentIndex == 0{
                    // Which means that user select incomplete in the segmented control
                    let _ = databaseController!.addTask(newTaskTitle: taskTitle, newTaskDescription: taskDescription, newTaskDueDate: taskDueDate!, newTaskStartDate: taskStartDate!, newTaskAddress: taskAddress, newTaskRepeat: false, newTaskHasBeenCompleted: false)
                }
                else{
                    // Which means that user select complete in the segmented control
                    let _ = databaseController!.addTask(newTaskTitle: taskTitle, newTaskDescription: taskDescription, newTaskDueDate: taskDueDate!, newTaskStartDate: taskStartDate!, newTaskAddress: taskAddress, newTaskRepeat: false, newTaskHasBeenCompleted: true)
                }
                
                // feedback of adding
                displayMessage(title: "Success", message: "Task has been added to the list", pop: true)
            }
            // If not input in some text field, display error message
            displayMessage(title: "Error", message: loadMessage(), pop: false)
        }
        else{
            // Which means that it is editing a task.
            if taskTitleTextField.text != "" && dueDateTextField.text != "" && descriptionTextField.text != ""{
                let taskTitle = taskTitleTextField.text!
                let taskStartDate = dateFormatter.date(from: startDateTextField.text!)
                let taskDueDate = dateFormatter.date(from: dueDateTextField.text!)
                let taskAddress = addressTextField.text!
                let taskDescription = descriptionTextField.text!
                // Update the task by the input
                
                if taskHasBeenCompletedSegmentedControl.selectedSegmentIndex == 0{
                    // Which means that user select incomplete in the segmented control
                    databaseController!.updateTask(newTask: task!, newTaskTitle: taskTitle, newTaskDescription: taskDescription, newTaskDueDate: taskDueDate!, newTaskStartDate: taskStartDate!, newTaskAddress: taskAddress, newTaskRepeat: false, newTaskHasBeenCompleted: false)
                }
                else{
                    // Which means that user select complete in the segmented control
                    databaseController!.updateTask(newTask: task!, newTaskTitle: taskTitle, newTaskDescription: taskDescription, newTaskDueDate: taskDueDate!, newTaskStartDate: taskStartDate!, newTaskAddress: taskAddress, newTaskRepeat: false, newTaskHasBeenCompleted: true)
                }
                // feedback of adding
                displayMessage(title: "Success", message: "Task has been update!", pop: true)
                // Go to the page before
                navigationController?.popViewController(animated: true)
            }
            // If not input in some text field, display error message
            displayMessage(title: "Error", message: loadMessage(), pop: false)
        }
    }
    
    // Create a date picker for changing date to String,
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?

    override func viewDidLoad() {
        // run when this page loading
        super.viewDidLoad()
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if task != nil {
            // Which means that user is trying to edit a task
            // Put all the task information as default value in the text Field.
            navigationItem.title = task!.taskTitle
            taskTitleTextField.text = task!.taskTitle
            startDateTextField.text = dateFormatter.string(from: task!.taskStartDate! as Date)
            dueDateTextField.text = dateFormatter.string(from: task!.taskDueDate! as Date)
            addressTextField.text = task!.taskAddress
            descriptionTextField.text = task!.taskDescription
            if task?.taskRepeat == true{
                taskRepeatSegmentedControl.selectedSegmentIndex = 1
            }
            else{
                taskRepeatSegmentedControl.selectedSegmentIndex = 0
            }
            if task?.taskHasBeenCompleted == true{
                taskHasBeenCompletedSegmentedControl.selectedSegmentIndex = 1
            }
            else{
                taskHasBeenCompletedSegmentedControl.selectedSegmentIndex = 0
            }
        }
        
        // Let user input date by datePicker
        // learn from: https://www.youtube.com/watch?v=aa-lNWUVY7g
        
        // Setup a tap gesture sensor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTaskViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        // Setup a datePicker after loading the view.
        datePicker = UIDatePicker()
        datePicker2 = UIDatePicker()
        
        // Set the validation of date, user cannot select a date prior the current date.
        // Learn from: https://stackoverflow.com/questions/37247389/swift-2-0-validation-on-datepicker-maximum-date
        datePicker?.minimumDate = Date()
        datePicker2?.minimumDate = Date()
        
        datePicker?.datePickerMode = .dateAndTime
        datePicker2?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(AddTaskViewController.dateChanged2(datePicker:)), for: .valueChanged)
        dueDateTextField.inputView = datePicker
        startDateTextField.inputView = datePicker2
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        // Input a datePicker, set this date to dueDateTextField
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dueDateTextField!.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @objc func dateChanged2(datePicker: UIDatePicker){
        // Input a datePicker, set this date to dueDateTextField
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        startDateTextField!.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        // If user tap somewhere else, end editing.
        view.endEditing(true)
    }
    
    func popHandler(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    func displayMessage(title: String, message: String, pop: Bool) {
        // Setup an alert to show user details about the Person
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        // If use input correctly, the feedback will lead to the page before,
        // else if user get an error, it should stay in current page.
        // Writing handler for UIAlertAction: https://stackoverflow.com/questions/24190277/writing-handler-for-uialertaction
        
        if pop{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: popHandler))
        }
        else{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadMessage() -> String{
        var errorMsg = "Please ensure all fields are filled:\n"
        if taskTitleTextField.text == "" {
            errorMsg += "- Must provide a task name\n"
        }
        if dueDateTextField.text == "" {
            errorMsg += "- Must provide due date\n"
        }
        if descriptionTextField.text == ""{
            errorMsg += "- Must provide description"
        }
        return errorMsg
    }
    
    // No prepare func because this page will no lead to another one.
}

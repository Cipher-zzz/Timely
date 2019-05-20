//
//  Task.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/3/19.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class Task: NSObject {
    
    var taskTitle: String
    var taskDescription: String
    var taskDueDate: Date
    var taskHasBeenCompleted: Bool
    //var taskTimeToRemind
    
    init(newTaskTitle: String,newTaskDescription: String, newTaskDueDate: Date, newTaskHasBeenCompleted: Bool){
        self.taskTitle = newTaskTitle
        self.taskDescription = newTaskDescription
        self.taskDueDate = newTaskDueDate
        self.taskHasBeenCompleted = newTaskHasBeenCompleted
    }
    
    func setTasktitle(newTaskTitle: String) -> Bool {
        if(newTaskTitle.count <= 100 && newTaskTitle.count > 0){
            taskTitle = newTaskTitle
            return true
        }
        else{
            return false
        }
    }
    
    func setTaskDescription(newTaskDescription: String) -> Bool {
        if(newTaskDescription.count <= 500 && newTaskDescription.count > 0){
            taskDescription = newTaskDescription
            return true
        }
        else{
            return false
        }
    }
    
    func setTaskDueDate(newTaskDueDate: Date) {
        if(newTaskDueDate > Date()){
            taskDueDate = newTaskDueDate as NSDate
            return true
        }
        else{
            return false
        }
    }
    
    func setTaskHasBeenCompleted(newTaskHasBeenCompleted: Bool) {
        taskHasBeenCompleted = newTaskHasBeenCompleted
    }
    
    func toString() -> String {
        return "Task: \(taskTitle) due at \(taskDueDate). Description: \(taskDescription)"
    }

}

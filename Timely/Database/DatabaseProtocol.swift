//
//  DatabaseProtocol.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/14.
//  Copyright © 2019 monash. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case completedTasks
    case tasks
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func taskListChange(change: DatabaseChange, tasks: [Task])
}

protocol DatabaseProtocol: AnyObject {
    
    func addTask(newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool) -> Task

    func deleteTask(task: Task)
    
    func addListener(listener: DatabaseListener)
    
    func removeListener(listener: DatabaseListener)
    
    func updateTask(settingTask:Task, newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool)
    
    func setTaskDate(settingTask:Task, newTaskDueDate: Date, newTaskStartDate: Date)
        
    func setTaskState(newTask:Task,newTaskHasBeenCompleted:Bool) 
}


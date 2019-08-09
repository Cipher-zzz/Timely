//
//  CoreDataController.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/14.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate{
    //let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    
    // Results
    var taskslistFetchedResultsController: NSFetchedResultsController<Task>?
    var repeatedtaskslistFetchedResultsController: NSFetchedResultsController<Task>?
    var completedtaskslistFetchedResultsController: NSFetchedResultsController<Task>?
    
    override init() {
        persistantContainer = NSPersistentContainer(name: "Tasks")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        // If there are no heroes in the database assume that the app is running
        // for the first time. Create the default team and initial superheroes.
        if fetchTasks().count == 0 {
            createDefaultEntries()
        }
    }
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    // Saving a new Task
    func addTask(newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool) -> Task {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task",
                                                       into: persistantContainer.viewContext) as! Task
        task.taskTitle = newTaskTitle
        task.taskDueDate = newTaskDueDate as NSDate
        task.taskStartDate = newTaskStartDate as NSDate
        task.taskAddress = newTaskAddress
        task.taskRepeat = newTaskRepeat
        task.taskDescription = newTaskDescription
        task.taskHasBeenCompleted = newTaskHasBeenCompleted
        saveContext()
        return task
    }
    
    // Updating a Task
    func updateTask(settingTask:Task, newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool) {
        let myDate: NSDate = newTaskDueDate as NSDate
        let myDate2: NSDate = newTaskStartDate as NSDate
        settingTask.setValue(newTaskTitle, forKey: "taskTitle")
        settingTask.setValue(newTaskDescription, forKey: "taskDescription")
        settingTask.setValue(myDate, forKey: "taskDueDate")
        settingTask.setValue(newTaskRepeat, forKey: "taskRepeat")
        settingTask.setValue(newTaskAddress, forKey: "taskAddress")
        settingTask.setValue(myDate2, forKey: "taskStartDate")
        settingTask.setValue(newTaskHasBeenCompleted, forKey: "taskHasBeenCompleted")

        saveContext()
    }
    
    // Setting Date
    func setTaskDate(settingTask:Task, newTaskDueDate: Date, newTaskStartDate: Date){
        let myDate: NSDate = newTaskDueDate as NSDate
        let myDate2: NSDate = newTaskStartDate as NSDate
        settingTask.setValue(myDate, forKey: "taskDueDate")
        settingTask.setValue(myDate2, forKey: "taskStartDate")
        
        saveContext()
    }
    
    
    func setTaskState(newTask:Task,newTaskHasBeenCompleted:Bool) {
        newTask.setValue(newTaskHasBeenCompleted, forKey: "taskHasBeenCompleted")
        
        saveContext()
    }
    

    // Deleting a Task
    func deleteTask(task: Task) {
        persistantContainer.viewContext.delete(task)
        saveContext()
    }
    
    func deleteRepeatTasks(){
        let deleteingTask = fetchRepeatTasks()
        for task in deleteingTask{
            persistantContainer.viewContext.delete(task)
        }
        saveContext()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.repeatedTasks || listener.listenerType == ListenerType.all {
            listener.taskListChange(change: .update, tasks: fetchRepeatTasks())
        }
        
        if listener.listenerType == ListenerType.tasks || listener.listenerType == ListenerType.all {
            listener.taskListChange(change: .update, tasks: fetchTasks())
        }
        
        if listener.listenerType == ListenerType.uncompleted || listener.listenerType == ListenerType.all {
            listener.taskListChange(change: .update, tasks: fetchUncompletedTasks())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func fetchTasks() -> [Task] {
        if taskslistFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "taskDueDate", ascending: true); fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            let predicate = NSPredicate(format: "taskRepeat=false", "Task")
            fetchRequest.predicate = predicate
            
            taskslistFetchedResultsController =
                NSFetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            taskslistFetchedResultsController?.delegate = self
            
            do {
                try taskslistFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var tasks = [Task]()
        if taskslistFetchedResultsController?.fetchedObjects != nil {
            tasks = (taskslistFetchedResultsController?.fetchedObjects)!
        }
        return tasks
    }
    
    func fetchRepeatTasks() -> [Task] {
        if repeatedtaskslistFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "taskDueDate", ascending: true); fetchRequest.sortDescriptors = [nameSortDescriptor]

            let predicate = NSPredicate(format: "taskRepeat=true", "Task")
            fetchRequest.predicate = predicate

            repeatedtaskslistFetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            repeatedtaskslistFetchedResultsController?.delegate = self
            do {
                try repeatedtaskslistFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        var tasks = [Task]()
        if repeatedtaskslistFetchedResultsController?.fetchedObjects != nil {
            tasks = (repeatedtaskslistFetchedResultsController?.fetchedObjects)!
        }
        return tasks
    }
    
    func fetchUncompletedTasks() -> [Task] {
        if completedtaskslistFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "taskDueDate", ascending: true); fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            let predicate = NSPredicate(format: "taskHasBeenCompleted=false", "Task")
            fetchRequest.predicate = predicate
            
            completedtaskslistFetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            completedtaskslistFetchedResultsController?.delegate = self
            do {
                try completedtaskslistFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        var tasks = [Task]()
        if completedtaskslistFetchedResultsController?.fetchedObjects != nil {
            tasks = (completedtaskslistFetchedResultsController?.fetchedObjects)!
        }
        return tasks
    }
    
    // MARK: - Fetched Results Conttroller Delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == taskslistFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.tasks {
                listener.taskListChange(change: .update, tasks:fetchTasks())
            }
            }
        }
        else if controller == repeatedtaskslistFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.repeatedTasks {
                listener.taskListChange(change: .update, tasks:fetchRepeatTasks())
            }
            }
        }
        else if controller == completedtaskslistFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.uncompleted {
                listener.taskListChange(change: .update, tasks:fetchUncompletedTasks())
            }
            }
        }
    }
    
    // MARK: - Default entries
    
    func createDefaultEntries() {
        let _ = addTask(newTaskTitle: "task1", newTaskDescription: "desc1", newTaskDueDate: Date().add(component: .hour, value: 1), newTaskStartDate: Date(), newTaskAddress: "Clayton", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        let _ = addTask(newTaskTitle: "task2", newTaskDescription: "desc2", newTaskDueDate: Date().add(component: .hour, value: 2), newTaskStartDate: Date(), newTaskAddress: "Monash Clayton", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        let _ = addTask(newTaskTitle: "task3", newTaskDescription: "desc3", newTaskDueDate: Date().add(component: .hour, value: 4), newTaskStartDate: Date().add(component: .hour, value: 3), newTaskAddress: "Melbourne AirpZort", newTaskRepeat: false, newTaskHasBeenCompleted: false)
        let _ = addTask(newTaskTitle: "task4", newTaskDescription: "desc4", newTaskDueDate: Date(), newTaskStartDate: Date(), newTaskAddress: "14 Rainforest", newTaskRepeat: false, newTaskHasBeenCompleted: true)
        let _ = addTask(newTaskTitle: "task5", newTaskDescription: "desc5", newTaskDueDate: Date(), newTaskStartDate: Date(), newTaskAddress: "14 Rainforest", newTaskRepeat: false, newTaskHasBeenCompleted: true)
        let _ = addTask(newTaskTitle: "task6", newTaskDescription: "desc6", newTaskDueDate: Date(), newTaskStartDate: Date(), newTaskAddress: "14 Rainforest", newTaskRepeat: false, newTaskHasBeenCompleted: true)
        
    }
    
}

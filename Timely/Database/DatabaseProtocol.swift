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
    //func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
    func taskListChange(change: DatabaseChange, tasks: [Task])
}

protocol DatabaseProtocol: AnyObject {
    //var defaultTeam: Team {get}
    
    func addTask(newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool) -> Task
    //func addTeam(teamName: String) -> Team
    //func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deleteTask(task: Task)
    //func deleteTeam(team: Team)
    //func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func updateTask(newTask:Task, newTaskTitle: String, newTaskDescription: String, newTaskDueDate: Date, newTaskStartDate: Date, newTaskAddress: String, newTaskRepeat: Bool, newTaskHasBeenCompleted: Bool)
    
    func setTaskState(newTask:Task,newTaskHasBeenCompleted:Bool) 
}


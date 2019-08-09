//
//  CompletedTaskTableViewController.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/13.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class CompletedTaskListTableViewController: UITableViewController,DatabaseListener,UISearchResultsUpdating {
    
    // Refer tothe two different sections in our Table View
    let SECTION_LIST = 0;
    let SECTION_COUNT = 1;
    // Properties used to store the reuse identifiers for each type of cell:
    let CELL_LIST = "taskCell"
    let CELL_COUNT = "completedTaskCell"
    
    //current list of tasks
    var currentList: [Task] = []
    var filtedTasks: [Task] = []
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Set the search controller
        filtedTasks = currentList
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //use constant SECTION properties to check which section is currently being looked at:
        if section == SECTION_LIST{
            //If it looking at the List section, then return the current number of tasks.
            return filtedTasks.count
        }
        else{
            //If we are looking at the total section, we return 1. PS: Only display the total.
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a dateFormatter to fomate the date
        // learn from: https://www.youtube.com/watch?v=aa-lNWUVY7g
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        //return different cell types depending on the section.
        if indexPath.section == SECTION_LIST{
            //We know that cell with CELL_LIST will always be this type of cell. Therefore use '!'
            let listCell = tableView.dequeueReusableCell(withIdentifier: CELL_LIST) as! TaskTableViewCell
            
            let task = filtedTasks[indexPath.row]
            listCell.dueDateLabel.text = dateFormatter.string(from: task.taskStartDate! as Date)
            
            let taskDate = task.taskDueDate! as Date
            
            // If the task is Over due, change the time color to red.
            if taskDate < Date(){
                listCell.dueDateLabel.textColor = UIColor.red
            }
            else{
                listCell.dueDateLabel.textColor = UIColor.blue
            }
            listCell.taskTitleLabel.text = task.taskTitle
            
            return listCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT)
        // Return the count cell
        if currentList.count == 1{
            countCell!.textLabel?.text = "1 task in List"
        }
        else if currentList.count == 0{
            countCell!.textLabel?.text = "No task in this list now, please create a new one!"
        }
        else{
            countCell!.textLabel?.text = "\(currentList.count) tasks in List"
        }
        countCell!.selectionStyle = .none
        return countCell!
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath:IndexPath) -> Bool {
        // listCell is editable but countCell not.
        if indexPath.section == SECTION_LIST {
            return true
        }
        else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        // When delete a task, delete it from the array.
        if editingStyle == .delete && indexPath.section == SECTION_LIST {
            // Current task  is the task object which need to delete.
            let currentTask = filtedTasks[indexPath.row]
            // Remove from the list
            self.filtedTasks.remove(at: indexPath.row)
            // Remove from the view
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Remove from the core data
            databaseController!.deleteTask(task: currentTask)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Show a buttom when user slide to the right.
        // Learn from a Blog:http://www.hangge.com/blog/cache/detail_1891.html
        let currentTask = filtedTasks[indexPath.row]
        // Creat "Incomplete" buttom
        let incomplete = UIContextualAction(style: .normal, title: "Incomplete") {
            (action, view, completionHandler) in
            completionHandler(true)
            // Set current task incompleted
            self.databaseController!.setTaskState(newTask: currentTask, newTaskHasBeenCompleted: false)
            tableView.reloadData()
        }
        incomplete.backgroundColor = UIColor(red: 52/255, green: 120/255, blue: 246/255,
                                           alpha: 1)
        
        // Return the Buttom
        let configuration = UISwipeActionsConfiguration(actions: [incomplete])
        return configuration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send the current task to task detail controller
        if segue.identifier == "taskDetailSegue" {
            let destination = segue.destination as! TaskDetailViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            destination.task = filtedTasks[selectedIndexPath!.row]
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        // Put the tasks which fit the search request into the filtedTasks list
        if let searchText = searchController.searchBar.text?.lowercased(),searchText.count > 0 {
            filtedTasks = currentList.filter({(task: Task) -> Bool in
                return task.taskTitle!.lowercased().contains(searchText)
            })
        }
        else{
            filtedTasks = currentList;
        }
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    var listenerType = ListenerType.repeatedTasks
    
    func taskListChange(change: DatabaseChange, tasks: [Task]) {
        currentList = tasks
        updateSearchResults(for: navigationItem.searchController!)
    }
}

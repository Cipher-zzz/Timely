//
//  TaskDetailViewController.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/15.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    var task: Task?
    
    // connect it to the database
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    // @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var taskStateLabel: UILabel!
    @IBOutlet weak var taskRepeatLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the database controller once from the App Delegate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if task != nil {
            navigationItem.title = task!.taskTitle
            taskLabel.text = "\(task!.taskTitle!)"
            //addressLabel.text = "Task Address: \(task!.taskAddress!)"
            descriptionLabel.text = "\(task!.taskDescription!)"
            let taskDate = dateFormatter.string(from: task!.taskDueDate! as Date)
            dueDateLabel.text = "\(taskDate)"
            let taskDate2 = dateFormatter.string(from: task!.taskStartDate! as Date)
            startDateLabel.text = "\(taskDate2)"
            if task?.taskHasBeenCompleted == true{
                taskStateLabel.text = "Task has been completed"
            }
            else{
                taskStateLabel.text = "Incompleted"
            }
            if task?.taskRepeat == true{
                taskRepeatLabel.text = "Repeat task"
            }
            else{
                taskRepeatLabel.text = "No repeat"
            }
            mapButton.setTitle(task!.taskAddress, for: .normal)
            
            let back = UserDefaults.init(suiteName: "group.Cipher.Timely")?.value(forKey: "backgroundPicture")
            if back != nil{
                self.backgroundImage.image = UIImage(data: back as! Data)?.alpha(0.3)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send the current task to task detail controller
        if segue.identifier == "editTaskSegue" {
            let destination = segue.destination as! AddTaskViewController
            destination.task = task
        }
        if segue.identifier == "mapSegue" {
            let destination = segue.destination as! TaskMapViewController
            destination.taskAddress = task!.taskAddress!
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

}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//
//  Task+CoreDataProperties.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/4.
//  Copyright © 2019 monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskDescription: String?
    @NSManaged public var taskDueDate: NSDate?
    @NSManaged public var taskHasBeenCompleted: Bool
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskStartDate: NSDate?
    @NSManaged public var taskAddress: String?
    @NSManaged public var taskRepeat: Bool

}

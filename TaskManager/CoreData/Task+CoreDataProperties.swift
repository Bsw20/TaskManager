//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date?
    @NSManaged public var taskStatus: String?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}

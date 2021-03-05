//
//  TaskModel.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit

struct TaskModel {
    var taskStatus: TaskStatus
    var title: String
    var date: Date
    var comment: String
}

enum TaskStatus: Int, CaseIterable {
    case new
    case inProcess
    case completed
}

//
//  TaskStatus.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit

enum TaskStatus: String, CaseIterable {
    case new = "new"
    case inProcess = "in process"
    case completed = "completed"
    
    func description() -> String {
        switch self {
        
        case .new:
            return "new"
        case .inProcess:
            return "in process"
        case .completed:
            return "completed"
        }
    }
    
    func index() -> Int {
        switch self {
        
        case .new:
            return 0
        case .inProcess:
            return 1
        case .completed:
            return 2
        }
    }
}

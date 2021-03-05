//
//  TaskStatus.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit

enum TaskStatus: Int, CaseIterable {
    case new
    case inProcess
    case completed
    
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
}

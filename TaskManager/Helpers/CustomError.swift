//
//  CustomError.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit

enum CustomError {
    case CoreDataError
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .CoreDataError:
            return NSLocalizedString("Core data error", comment: "")
        }
    }
}


//
//  CoreDataManager.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    public static var shared = CoreDataManager()
    
    private var container: NSPersistentContainer!
    init() {
        print("init")
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        print(container == nil)
    }
    
    public func retrieveTasks(predicate: NSPredicate?,  completion: @escaping (Result<[Task], Error>) -> Void){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        do {
            let tasks = try container.viewContext.fetch(request)
            print("\(tasks.count) tasks")
            completion(.success(tasks))
        } catch {
            completion(.failure(CustomError.CoreDataError))
        }
    }
    
    public func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    public func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    public func initNewTask() -> Task {
        return Task(context: container.viewContext)
    }
}

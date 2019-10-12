//
//  DataBaseService.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 7/30/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOSTrainee_AntonSamonin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(of type: T.Type, sortAttribute: String?, predicateFormat: String? = nil, arg: CVarArg? = nil ) -> [T] {
        let entityName = String(describing: type)
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            fetchRequest.predicate = predicateFormat != nil && arg != nil ? NSPredicate(format: predicateFormat!, arg!) : nil
            
            fetchRequest.sortDescriptors = sortAttribute != nil ? [NSSortDescriptor(key: sortAttribute, ascending: true)] : []
            
            let objects = try context.fetch(fetchRequest) as? [T]
            return objects ?? [T]()
        } catch {
            return [T]()
        }
    }
    
    func delete(object: NSManagedObject) {
        context.delete(object)
    }
}




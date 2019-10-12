//
//  Category.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 22/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import CoreData

enum CategoryType: String, Codable {
    case children = "Дети"
    case adults = "Взрослые"
    case elderly = "Пожилые"
    case animals = "Животные"
    case events = "Мероприятия"
}

class Category: NSManagedObject, Codable {
    
    @NSManaged var id: Int16
    @NSManaged var name: String
    @NSManaged var events: [Event]?
    
    var categoryType: CategoryType? {
        return CategoryType(rawValue: self.name)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Category", in: CoreDataManager.instance.context) else {
            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: CoreDataManager.instance.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int16.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension Category {
    
    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)
    
    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)
    
}



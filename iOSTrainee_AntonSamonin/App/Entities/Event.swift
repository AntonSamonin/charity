//
//  Event.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 22/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject, Codable {
    
    @NSManaged var id: Int32
    @NSManaged var categoryId: Int32
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var organizationName: String
    @NSManaged var organizationAddress: String
    @NSManaged var phoneNumbers: String
    @NSManaged var eventDescription: String
    @NSManaged var photos: [String]?
    @NSManaged var category: Category?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case date
        case organizationName = "organization_name"
        case organizationAddress = "organization_address"
        case phoneNumbers = "phone_numbers"
        case eventDescription = "description"
        case photos
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: CoreDataManager.instance.context) else {
            fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: CoreDataManager.instance.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.categoryId = try container.decode(Int32.self, forKey: .categoryId)
        self.date = try container.decode(Date.self, forKey: .date)
        self.organizationName = try container.decode(String.self, forKey: .organizationName)
        self.organizationAddress = try container.decode(String.self, forKey: .organizationAddress)
        self.phoneNumbers = try container.decode(String.self, forKey: .phoneNumbers)
        self.eventDescription = try container.decode(String.self, forKey: .eventDescription)
        self.title = try container.decode(String.self, forKey: .title)
        self.photos = try container.decode([String].self, forKey: .photos)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(organizationName, forKey: .organizationName)
        try container.encode(organizationAddress, forKey: .organizationAddress)
        try container.encode(phoneNumbers, forKey: .phoneNumbers)
        try container.encode(eventDescription, forKey: .eventDescription)
        try container.encode(photos, forKey: .photos)
    }
}

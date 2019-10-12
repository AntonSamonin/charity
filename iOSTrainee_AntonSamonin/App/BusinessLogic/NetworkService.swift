//
//  NetworkService.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 22/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class NetworkService {
    
    static let instance = NetworkService()
    
    let ref = Database.database().reference()
    
    private init() {}
    
    func loadCategoties(completion: @escaping ([Category]?, LoadDataErrors?) -> Void) {
        
        if let networkReachability = NetworkReachabilityManager(), networkReachability.isReachable {
            
            ref.child("categories").observeSingleEvent(of: .value) { [weak self] (snapshot) in
                
                let snapshotValue = snapshot.value as? [AnyObject]
                
                guard let fireBaseCategories = snapshotValue else {
                    self?.loadCategoriesFromBundle(becauseOf: .serverError, completion: completion)
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: fireBaseCategories, options: [])
                    let decoder = JSONDecoder()
                    let categories  = try! decoder.decode([Category].self, from: jsonData)
                    completion(categories,nil)
                } catch {
                    completion(nil, .parsingError)
                    print(error.localizedDescription)
                }
            }
        } else {
            loadCategoriesFromBundle(becauseOf: .noConnection, completion: completion)
        }
    }
    
    func loadEvents(for category: Category, completion: @escaping ([Event]?, LoadDataErrors?) -> Void) {
        
        if let networkReachability = NetworkReachabilityManager(), networkReachability.isReachable {
            
            ref.child("events").observeSingleEvent(of: .value) { [weak self] (snapshot) in
                
                let snapshotValue = snapshot.value as? [AnyObject]
                
                guard let fireBaseEvents = snapshotValue else {
                    self?.loadEventsFromBundle(becauseOf: .serverError, for: category, completion: completion)
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: fireBaseEvents, options: [])
                    let decoder = JSONDecoder()
                    let events = try! decoder.decode([Event].self, from: jsonData).filter{$0.categoryId == category.id}
                    completion(events,nil)
                } catch {
                    completion(nil, LoadDataErrors.parsingError)
                    print(error.localizedDescription)
                }
            }
        } else {
            loadEventsFromBundle(becauseOf: .noConnection, for: category, completion: completion)
        }
    }
    
    private func loadCategoriesFromBundle(becauseOf error: LoadDataErrors, completion:([Category]?, LoadDataErrors?) -> Void) {
        if let filepath = Bundle.main.path(forResource: "CategoriesJSON", ofType: "json"){
            do {
                let categoriesStr = try String(contentsOfFile: filepath)
                guard let jsonData = categoriesStr.data(using: .utf8) else {return}
                let decoder = JSONDecoder()
                let categoriesDict = try! decoder.decode([String:[Category]].self, from: jsonData)
                let categories = categoriesDict["categories"]
                completion(categories, error)
            } catch {
                completion(nil, .parsingError)
                print(error.localizedDescription)
            }
        } else {
            print("Файл не найден")
        }
    }
    
    private func loadEventsFromBundle(becauseOf error: LoadDataErrors,for category: Category,completion: ([Event]?, LoadDataErrors?) -> Void) {
        if let filepath = Bundle.main.path(forResource: "EventsJSON", ofType: "json") {
            do {
                let eventsStr = try String(contentsOfFile: filepath)
                guard let jsonData = eventsStr.data(using: .utf8) else {return}
                let decoder = JSONDecoder()
                let eventsDict = try! decoder.decode([String:[Event]].self, from: jsonData)
                let events = eventsDict["events"]?.filter{ $0.categoryId == category.id }
                completion(events, error)
            } catch {
                completion(nil, .parsingError)
                print(error.localizedDescription)
            }
        }
    }
}

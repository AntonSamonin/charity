//
//  CategoriesViewModel.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 22/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewModel {
    
    let error = PublishRelay<LoadDataErrors>()
    
    func getCoreDataCategories() -> Observable<[Category]> {
        return Observable.create { observer in
            let coreDataCategories = CoreDataManager.instance.fetch(of: Category.self, sortAttribute: "id")
            observer.onNext(coreDataCategories)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getCategoriesRx() -> Observable<[Category]> {
        return Observable.create { observer in
            
            var coreDataCategories = CoreDataManager.instance.fetch(of: Category.self, sortAttribute: "id")
            
            NetworkService.instance.loadCategoties(completion: { (categories, error) in
                
                if categories != nil {
                    
                    for category in coreDataCategories {
                        CoreDataManager.instance.delete(object: category)
                    }
                    CoreDataManager.instance.save()
                    
                    coreDataCategories = CoreDataManager.instance.fetch(of: Category.self, sortAttribute: "id")
                    
                    observer.onNext(coreDataCategories)
                }
                
                if let error = error {
                    observer.onError(error)
                }
                
                observer.onCompleted()
            })
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: .global()))
            .observeOn(MainScheduler.instance)
            .share()
            .catchError { [weak self] error -> Observable<[Category]> in
                
                guard let error  = error as? LoadDataErrors else {
                    return .empty()
                }
                switch error {
                case .noConnection:
                    self?.error.accept(.noConnection)
                    return self?.getCoreDataCategories() ?? .just([])
                case .serverError:
                    self?.error.accept(.serverError)
                    return self?.getCoreDataCategories() ?? .just([])
                default: break
                }
                return  Observable.just([])
        }
    }
}

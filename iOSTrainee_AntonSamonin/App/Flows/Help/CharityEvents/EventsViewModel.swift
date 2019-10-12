//
//  EventsViewModel.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 23/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventsViewModel {
    
    let error = PublishRelay<LoadDataErrors>()
    
    func getEventsRx(for category: Category) -> Observable<[Event]> {
        return Observable.create { observer in
            
            NetworkService.instance.loadEvents(for: category) { (events, error) in
                
                if let loadedEvents = events {
                    if let events = category.events {
                        events.forEach{category.removeFromEvents($0)}
                    }
                    
                    loadedEvents.forEach{category.addToEvents($0)}
                    
                    CoreDataManager.instance.save()
                    
                    observer.onNext(category.events ?? [Event]())
                }
                
                if let error = error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: .global()))
            .observeOn(MainScheduler.instance)
            .share()
            .catchError { [weak self] error -> Observable<[Event]>  in

                guard let error  = error as? LoadDataErrors else {
                    return .empty()
                }
                switch error {
                case .noConnection:
                    self?.error.accept(.noConnection)
                    return  .just(category.events ?? [])
                case .serverError:
                    self?.error.accept(.serverError)
                    return  .just(category.events ?? [])
                default: break
                }
                return  Observable.just([])
        }
    }
    
    func eventDateFormatter(eventDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, hh:mm"
        dateFormatter.locale = Locale(identifier: "RU")
        return dateFormatter.string(from: eventDate)
    }
}


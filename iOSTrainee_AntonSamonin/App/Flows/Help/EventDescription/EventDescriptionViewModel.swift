//
//  File.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 24/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventDescriptionViewModel {
    
    let needAuth: Driver<Bool>
    let helpClothesTap = PublishRelay<()>()
    let becomeAVolunteerTap = PublishRelay<()>()
    let professionalHelpTap = PublishRelay<()>()
    let moneyHelpTap = PublishRelay<()>()
    
    
    init() {
        self.needAuth = Observable.merge(helpClothesTap.asObservable(),
                                    becomeAVolunteerTap.asObservable(),
                                    professionalHelpTap.asObservable(),
                                    moneyHelpTap.asObservable())
            .flatMapLatest { _ in
                return Driver.just(true)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func eventDateFormatter(eventDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, hh:mm"
        dateFormatter.locale = Locale(identifier: "RU")
        return dateFormatter.string(from: eventDate)
    }
}

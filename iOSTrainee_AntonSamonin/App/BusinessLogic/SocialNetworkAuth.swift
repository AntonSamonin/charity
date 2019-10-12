//
//  SocialNetworkAuth.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/14/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import RxSwift
import RxCocoa

class SocialNetworkAuth {
    
    static let shared = SocialNetworkAuth()
    
    private init() {}
    
    func socialNetworkSignIn() -> Observable<Bool> {
        return Observable.create { observer in
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
            .delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
    }
}

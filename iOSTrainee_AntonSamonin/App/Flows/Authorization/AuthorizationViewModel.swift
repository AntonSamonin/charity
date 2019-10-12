//
//  AuthorizationViewModel.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/8/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class AuthorizationViewModel {
    
    let login = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    let signedIn = PublishRelay<Bool>()
    let loginTap = PublishRelay<()>()
    let vkTap = PublishRelay<()>()
    let fbTap = PublishRelay<()>()
    let okTap = PublishRelay<()>()
    let validateUsername: Driver<ValidationResult>
    let validatePassword: Driver<ValidationResult>
    let allowEntry: Driver<Bool>
    let loading = ActivityIndicator()
    let keyboardHeight: Observable<Notification>
    
    init() {
        self.validateUsername = login
            .flatMapLatest { login -> Observable<ValidationResult> in
                guard let login = login else {
                    return .just(.empty)
                }
                return  ValidationService.sharedValidationService.validateUsername(login)
            }
            .asDriver(onErrorJustReturn: .failed(message: "Error"))
        
        self.validatePassword = password
            .map { password -> ValidationResult in
                guard let password = password else {
                    return .empty
                }
                return ValidationService.sharedValidationService.validatePassword(password)
            }
            .asDriver(onErrorJustReturn: .failed(message: "Error"))
        
        self.allowEntry = Driver
            .combineLatest(validateUsername, validatePassword, loading) { username, password, loading in
                return username.isValid && password.isValid && !loading
            }
            .distinctUntilChanged()
        
        self.keyboardHeight = Observable.from([
            NotificationCenter.default.rx
                .notification(UIApplication.keyboardWillShowNotification),
            NotificationCenter.default.rx
                .notification(UIApplication.keyboardWillHideNotification)])
            .merge()
            .distinctUntilChanged()
    }
    
    
    func singIn() -> Driver<Bool> {
        let usernameAndPassword = Observable
            .combineLatest(login, password) {(username: $0, password: $1)}
        
        return loginTap.withLatestFrom(usernameAndPassword)
            .flatMapLatest { [loading] pair -> Observable<Bool> in
                guard let username = pair.username, let password = pair.password else {
                    return Observable.just(false)
                }
                return Auth.auth().rx.signIn(withEmail: username, password: password)
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: false)
            .do(onNext: { [weak self] success in
                self?.signedIn.accept(success)
            })
    }
    
    func socialNetworkSignIn() -> Driver<Bool> {
        
        return Observable.merge(vkTap.asObservable(),
                                fbTap.asObservable(),
                                okTap.asObservable())
            .flatMapLatest { [loading] _ -> Observable<Bool> in
                SocialNetworkAuth.shared.socialNetworkSignIn()
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: false)
            .do(onNext: {success in
                self.signedIn.accept(success)
            })
    }
}

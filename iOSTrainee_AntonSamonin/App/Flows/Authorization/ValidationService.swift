//
//  ValidationService.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/12/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation
import RxSwift

class ValidationService: ValidationServiceDelegate {
    
    static let sharedValidationService = ValidationService()
    
    private init () {}
    
    // validation
    
    let minPasswordCount = 5
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        return .just(.ok(message: "Username available"))
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
}

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

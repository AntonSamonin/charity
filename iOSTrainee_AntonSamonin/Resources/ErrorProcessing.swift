//
//  Error Processing.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Anton Samonin on 8/21/19.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import Foundation

enum LoadDataErrors: Error {
    
    case noConnection
    
    case serverError
    
    case emptyDataBase
    
    case parsingError
    
    case unknownError
}

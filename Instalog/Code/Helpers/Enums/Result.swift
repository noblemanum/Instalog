//
//  Result.swift
//  Instalog
//
//  Created by Dimon on 13.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(value: T)
    case failure(error: ErrorType)
}


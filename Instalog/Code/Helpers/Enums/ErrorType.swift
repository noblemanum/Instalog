//
//  Errors.swift
//  Instalog
//
//  Created by Dimon on 13.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

enum ErrorType: Error {
    
    case statusCode(Int)
    case notFound
    case badRequest
    case unauthorized
    case notAcceptable
    case unprocessable
    case zeroData
    case offlineMode
    case serverUnreachable
    case otherError(Error)
    
    func getErrorDescription() -> String {
        switch self {
        case .statusCode(let code):
            return "Response with code = \(code)"
        case .notFound:
            return "Not found"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unathorized"
        case .notAcceptable:
            return "Not acceptable"
        case .unprocessable:
            return "Unprocessable"
        case .offlineMode:
            return "Offline mode"
        case .serverUnreachable:
            return "Could not connect to the server."
        case .zeroData:
            return "No data was received"
        case .otherError(let error):
            return error.localizedDescription
        }
    }
}

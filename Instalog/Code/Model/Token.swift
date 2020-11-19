//
//  Token.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

struct Token: Codable {
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}

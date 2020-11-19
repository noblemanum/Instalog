//
//  Decoder.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

class Decoder {
    
    class func decode<T: Decodable>(data: Data?, decoder: JSONDecoder = JSONDecoder()) -> T? {
        if let data = data,
            let results = try? decoder.decode(T.self, from: data) {
            return results
        } else {
            print("Either no data was returned, or data was not serialized.")
            return nil
        }
    }
}

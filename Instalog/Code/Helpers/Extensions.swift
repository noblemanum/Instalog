//
//  Extensions.swift
//  Instalog
//
//  Created by Dimon on 20.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionView Extension

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type,
                                              nib: Bool = true) {
        
        let reuseIdentifier = String(describing: cellType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func register<View: UICollectionReusableView>(viewType: View.Type,
                                                  kind: String,
                                                  nib: Bool = true) {
        
        let reuseIdentifier = String(describing: viewType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        } else {
            register(viewType,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type,
                                                 for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType),
                                   for: indexPath) as! Cell
    }
    
    func dequeueSupplementaryView<View: UICollectionReusableView>(of viewType: View.Type, kind: String, for indexPath: IndexPath) -> View {
        
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: String(describing: viewType),
                                                for: indexPath) as! View
    }
}

// MARK: - URL Extension

extension URL {
    func withQueries(_ query: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}

// MARK: - String Extension

extension String {
    var numbers: String {
        return filter { "0"..."9" ~= $0 }
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let jsonDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

// MARK: - UIImage Extension

extension UIImage {
    func toBase64() -> String? {
        guard
            let imageData = self.pngData()?.base64EncodedData(),
            let base64ImageString = String(data: imageData, encoding: .utf8) else {
                return nil
        }
        return base64ImageString
    }
}




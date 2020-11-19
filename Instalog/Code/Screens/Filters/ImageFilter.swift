//
//  ImageFilter.swift
//  Instalog
//
//  Created by Dimon on 18.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

protocol ImageFilter {
    var name: String { get }
    var parameters: [String: Any] { get }
}

extension ImageFilter {
    
    func apply(to originalImage: UIImage) -> UIImage? {
        guard let image = CIImage(image: originalImage),
              name != "Original" else {
            return originalImage
        }
        
        let context = CIContext()
        let parameters = self.parameters.merging([kCIInputImageKey: image], uniquingKeysWith: { _, rhs in rhs })
        
        guard let filter = CIFilter(name: name, parameters: parameters),
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

struct GaussianBlurFilter: ImageFilter {
    
    let name = "CIGaussianBlur"
    let parameters: [String: Any]
    
    init(radius: CGFloat = 3.0) {
        parameters = [
            kCIInputRadiusKey: radius,
        ]
    }
}

struct NoirFilter: ImageFilter {
    
    let name = "CIPhotoEffectNoir"
    let parameters = [String: Any]()
}

struct SepiaFilter: ImageFilter {
    
    let name = "CISepiaTone"
    let parameters = [String: Any]()
}

struct ColorInvertFilter: ImageFilter {
    
    let name = "CIColorInvert"
    let parameters = [String: Any]()
}

struct VignetteFilter: ImageFilter {
    
    let name = "CIVignette"
    let parameters: [String: Any]
    
    init(radius: CGFloat = 3.0, intensity: CGFloat = 3.0) {
        parameters = [
            kCIInputRadiusKey: radius,
            kCIInputIntensityKey: intensity,
        ]
    }
}

struct Original: ImageFilter {
    let name = "Original"
    let parameters = [String: Any]()
}

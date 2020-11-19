//
//  LoadingIndicator.swift
//  Instalog
//
//  Created by Dimon on 31.08.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class LoadingIndicator {
    
    let backgroundView: UIView
    let blackView: UIView
    let loadingIndicator = UIActivityIndicatorView()
    
    init(uiView: UIView) {
        self.backgroundView = uiView
        blackView = UIView(frame: backgroundView.bounds)
    }
    
    func show() {
        blackView.backgroundColor = .black
        blackView.alpha = 0.7
        
        loadingIndicator.frame.size = CGSize(width: 50, height: 50)
        loadingIndicator.center.x = blackView.bounds.midX
        loadingIndicator.center.y = blackView.bounds.midY
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .whiteLarge
        blackView.addSubview(loadingIndicator)
        backgroundView.addSubview(blackView)
        loadingIndicator.startAnimating()
    }
    
    func hide() {
        loadingIndicator.stopAnimating()
        blackView.removeFromSuperview()
    }
}


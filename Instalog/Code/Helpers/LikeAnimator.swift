//
//  LikeAnimator.swift
//  Instalog
//
//  Created by Dimon on 25.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class LikeAnimator {
    
    let container: UIView
    let layoutConstraints: NSLayoutConstraint
    
    init(container: UIView, layoutConstraints: NSLayoutConstraint) {
        self.container = container
        self.layoutConstraints = layoutConstraints
    }
    
    func animate(completion: @escaping () -> Void) {
        (layoutConstraints.firstItem as? UIView)?.isHidden = false

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .curveLinear,
                       animations: { [weak self] in
                        
                        self?.layoutConstraints.constant = 100
                        self?.container.layoutIfNeeded()
            }, completion: {
                [weak self] _ in

                UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
                    self?.layoutConstraints.constant = 0.5
                    self?.container.layoutIfNeeded()
                }) { _ in
                    (self?.layoutConstraints.firstItem as? UIView)?.isHidden = true
                    completion()
                }
        })
    }

    
}

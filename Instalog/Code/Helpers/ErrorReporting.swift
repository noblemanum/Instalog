//
//  ErrorReporting.swift
//  Instalog
//
//  Created by Dimon on 25.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class ErrorReporting {
    
    class func showMessage(for viewController: UIViewController,
                           title: String? = "Unknown error!",
                           message: String? = "Please, try again later.",
                           withDismissOption dismiss: Bool = false,
                           completion: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        switch dismiss {
        case true:
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                viewController.navigationController?.viewControllers.removeLast()
            }))
        case false:
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

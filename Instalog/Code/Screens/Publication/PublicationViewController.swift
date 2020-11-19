//
//  ShareDescriptionViewController.swift
//  Instalog
//
//  Created by Dimon on 25.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class PublicationViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var descriptionTextField: UITextField!
    
    // MARK: - Properties
    
    var finalImage: UIImage?
    
    // MARK: - View Controller Live Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = finalImage else {
            return
        }
        
        photoView.image = image
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
    }
    
    // MARK: - Private Methods
    
    @objc private func shareButtonTapped() {
        
        guard let image = finalImage?.toBase64() else {
            ErrorReporting.showMessage(for: self, withDismissOption: true)
            return
        }
        
        let loadingIndicator = LoadingIndicator(uiView: UIApplication.shared.keyWindow!)
        loadingIndicator.show()
        
        ServerDataProvider.shared.newPost(imageInBase64: image, description: descriptionTextField.text ?? "") { (result) in
            switch result {
            case .success(value: _):
                DispatchQueue.main.async {
                    loadingIndicator.hide()
                    self.performSegue(withIdentifier: "UnwindToFeed", sender: self)
                    self.navigationController?.popToRootViewController(animated: false)
                }
            case .failure(error: let error):
                DispatchQueue.main.async {
                    loadingIndicator.hide()
                    ErrorReporting.showMessage(for: self,
                                               title: nil,
                                               message: error.getErrorDescription(),
                                               withDismissOption: true)
                }
            }
        }
    }
}

//
//  AuthorizationViewController.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - Properties
    
    static var currentUserID: String?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextField.delegate = self
        passwordTextField.delegate = self
        setLoginButtonState()
    }
    
    // MARK: - Actions
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        setLoginButtonState()
    }
    
    @IBAction private func signInButtonTapped(_ sender: UIButton) {
        let loadingIndicator = LoadingIndicator(uiView: view)
        loadingIndicator.show()
        
        guard let login = loginTextField.text,
              let password = passwordTextField.text else {
            loadingIndicator.hide()
            return
        }
        
        ServerDataProvider.shared.signIn(login: login, password: password) { (result) in
            
            switch result {
            case .success(value: let token):
                ServerDataProvider.token = token.value
                DispatchQueue.main.async {
                    loadingIndicator.hide()
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewControllerID")
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                }
                ServerDataProvider.shared.currentUser { (result) in
                    switch result {
                    case .success(value: let user):
                        AuthorizationViewController.currentUserID = user.id
                    case.failure(error: let error):
                        print(error.getErrorDescription())
                    }
                }
            case .failure(error: let error):
                DispatchQueue.main.async {
                    loadingIndicator.hide()
                    ErrorReporting.showMessage(for: self, title: nil, message: error.getErrorDescription())
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func setLoginButtonState() {
        if loginTextField.text == "" || passwordTextField.text == "" {
            signInButton.isEnabled = false
            signInButton.alpha = 0.3
        } else {
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
        }
    }
}

    // MARK: - Text Field Delegate

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginTextField.text != "", passwordTextField.text != "" {
            signInButtonTapped(signInButton)
            view.endEditing(true)
            return true
        } else {
            return false
        }
    }
}

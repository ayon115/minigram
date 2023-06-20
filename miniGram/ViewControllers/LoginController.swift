//
//  LoginController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 2/5/23.
//

import UIKit
import Alamofire
import ActionKit
import KeychainSwift

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loginViewModel: LoginViewModel = LoginViewModel()
    
    let saveCredentials = "saveCredentials"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveSwitch.addControlEvent(.valueChanged) {
            print("Current Switch State = \(self.saveSwitch.isOn)")
        }
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        let userDefaults = UserDefaults.standard
        let isSaveOn = userDefaults.bool(forKey: saveCredentials)
        self.saveSwitch.isOn = isSaveOn
        if isSaveOn == true {
            let keychain = KeychainSwift()
            let email = keychain.get("email") ?? ""
            let password = keychain.get("password") ?? ""
            self.emailField.text = email
            self.passwordField.text = password
        }
        
    }
    
    func validate () -> String {
        guard let email = self.emailField.text, self.loginViewModel.isValidEmail(email: email) else {
            return self.loginViewModel.emailInvalid
        }
        
        guard let password = self.passwordField.text, password.count >= 6 else {
            return self.loginViewModel.passwordInvalid
        }
        
        return ""
    }
    


    @IBAction func onClickLoginButton () {
        print("login button was clicked")
        
        let validationError = self.validate()
        if validationError.count > 0 {
            
            let alertController = UIAlertController(title: "Validation Error", message: validationError, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Close", style: .cancel)
            alertController.addAction(cancelButton)
            self.present(alertController, animated: true)
            
            return
        }
        
        let userDefaults = UserDefaults.standard
        let keychain = KeychainSwift()
        if self.saveSwitch.isOn {
            userDefaults.set(true, forKey: self.saveCredentials)
            keychain.set(self.emailField.text!, forKey: "email")
            keychain.set(self.passwordField.text!, forKey: "password")
        } else {
            userDefaults.set(false, forKey: self.saveCredentials)
            keychain.delete("email")
            keychain.delete("password")
        }
        userDefaults.synchronize()
        
        self.login(email: self.emailField.text!, password: self.passwordField.text!)
    }
    
    func login (email: String, password: String) {
    
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.loginViewModel.login(email: email, password: password) { loginResponse, error in
            if let loginResponse = loginResponse {
                self.saveAuthInfo(response: loginResponse)
                self.makeTransitionToHome()
            } else if let error = error {
                MinigramApp.showAlert(from: self, title: "Login failed", message:  error.localizedDescription + ". Please try again later.")
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func saveAuthInfo (response: LoginResponse?) {
        if let loginResponse = response {
            if let userId = loginResponse.user?.id, let jwt = loginResponse.jwt {
                let defaults = UserDefaults.standard
                defaults.setValue(userId, forKey: "userId")
                defaults.setValue(jwt, forKey: "jwt")
                defaults.synchronize()
            }
        }
    }
    
    func makeTransitionToHome () {
        
        if let homeTabBarController = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.homeTabBarController) as? UITabBarController {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = homeTabBarController
                }
            }
        }
    }
    
    // Data Storage
    // 1. UserDefaults
    // 2. Secure Storage - Keychain
    // 3. database - core data / sqlite
}

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
        guard let email = self.emailField.text, isValidEmail(email: email) else {
            return "The email is invalid. Please enter a valid email."
        }
        
        guard let password = self.passwordField.text, password.count >= 6 else {
            return "Passowrd too short. The password must have at least 6 characters."
        }
        
        return ""
    }
    
    func isValidEmail (email: String) -> Bool {
        // write your email validation code, return true if valid
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let regex = try! NSRegularExpression(pattern: emailRegEx)
        let nsRange = NSRange(location: 0, length: email.count)
        let results = regex.matches(in: email, range: nsRange)
        if results.count == 0 {
            return false
        }
        return  true
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
        
        let url = MinigramApp.apiBaseUrl + "/api/auth/local"
        let loginRequest = LoginRequest(identifier: email, password: password)
        let headers: HTTPHeaders = [:]
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        AF.request(url, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: nil).responseDecodable(of: LoginResponse.self) { response in
            debugPrint(response)
            
            switch (response.result) {
                case .success:
                if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            self.makeTransitionToHome()
                        } else {
                            if let errorMessage = response.value?.error?.message {
                                MinigramApp.showAlert(from: self, title: "Login failed", message:  errorMessage + ". Please try again later.")
                            } else {
                                MinigramApp.showAlert(from: self, title: "Login failed", message: "Login failed. Please try again later.")
                            }
                        }
                    }
                    break
                case let .failure(error):
                    MinigramApp.showAlert(from: self, title: "Login failed", message: error.localizedDescription)
                    break
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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

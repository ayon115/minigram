//
//  LoginViewModel.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 20/6/23.
//

import Foundation

class LoginViewModel {
    
    var loginService: LoginService = LoginService ()
    
    var emailInvalid: String {
        return "The email is invalid. Please enter a valid email."
    }
    
    var passwordInvalid: String {
        return "Passowrd too short. The password must have at least 6 characters."
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
    
    func login (email: String, password: String, done: @escaping (LoginResponse?, Error?) -> ()) {
        
        self.loginService.performLogin(email: email, password: password) { response in
            done(response, nil)
        } onError: { error in
            done(nil, error)
        }

    }

}

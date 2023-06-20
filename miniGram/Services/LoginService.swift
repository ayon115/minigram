//
//  LoginService.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 20/6/23.
//

import Foundation
import Alamofire

class LoginService {
    
    func performLogin (email: String, password: String, onSuccess: @escaping (LoginResponse?) -> (), onError: @escaping (Error?) -> ()) {
        
        let url = MinigramApp.apiBaseUrl + "/api/auth/local"
        let loginRequest = LoginRequest(identifier: email, password: password)
        let headers: HTTPHeaders = [:]
        
        //self.activityIndicator.isHidden = false
        //self.activityIndicator.startAnimating()
        
        AF.request(url, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: nil).responseDecodable(of: LoginResponse.self) { response in
            debugPrint(response)
            
            switch (response.result) {
                case .success:
                if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            onSuccess(response.value)
                            //self.saveAuthInfo(response: response.value)
                           // self.makeTransitionToHome()
                        } else {
                            onSuccess(nil)
                           /* if let errorMessage = response.value?.error?.message {
                                MinigramApp.showAlert(from: self, title: "Login failed", message:  errorMessage + ". Please try again later.")
                            } else {
                                MinigramApp.showAlert(from: self, title: "Login failed", message: "Login failed. Please try again later.")
                            } */
                        }
                    }
                    break
                case let .failure(error):
                    onError(error)
                   // MinigramApp.showAlert(from: self, title: "Login failed", message: error.localizedDescription)
                    break
            }
           // self.activityIndicator.stopAnimating()
           // self.activityIndicator.isHidden = true
        }
    }
    
}

//
//  MinigramApp.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 29/4/23.
//

import Foundation
import UIKit

class MinigramApp {
    static let appName = "MiniGram"
    
    
    static let loginNavigationController = "LoginNavigationController"
    static let loginController = "LoginController"
    static let forgotController = "ForgotController"
    static let homeController = "HomeController"
    static let searchController = "SearchController"
    static let profileController = "ProfileController"
    static let PostController = "PostController"
    static let homeTabBarController = "HomeTabBarController"
    
    static let apiBaseUrl = "http://localhost:1337"
    static let authorizationHeader = "bearer d4c8705a78946258381fdac8ad19d1ba197b2f260aa32bda67c3189531ef4988b0e19474e8c6c6390356f14f000a6392a2da0f38ac630a96dac0db57a27aee2aeb256ef03f0c2dc6221eec00a2f1ffb10ac84bb3ba8042df26b6243a569d38c5b83f8438e46d85c4af5e42ff33b750a8f253f53a814a71e44082c10cd774ed3f"

    static func showAlert (from: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Close", style: .cancel)
        alertController.addAction(cancelButton)
        from.present(alertController, animated: true)
    }
    
}


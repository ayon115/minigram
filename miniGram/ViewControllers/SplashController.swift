//
//  SplashController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 29/4/23.
//

import UIKit

class SplashController: UIViewController {
    
    @IBOutlet var appNameLabel: UILabel!
    
    var splashViewModel: SplashViewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.text = self.splashViewModel.appName()
        
       // Timer(timeInterval: 5.0, target: self, selector: #selector(timerFireDetector), userInfo: nil, repeats: false).fire()
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFireDetector), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func timerFireDetector () {
        print("timeFireDetector func called.")
        self.goToLoginScreen()
    }
    
    func goToLoginScreen() {
        print("go to login screen")
        
        /*
        if let loginNavigationController = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.loginNavigationController) as? UINavigationController {
           // self.present(loginNavigationController, animated: true)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = loginNavigationController
                }
            }
        }
        
        if let loginController = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.loginController) as? LoginController {
            self.present(loginController, animated: true)
        }
         */
         
         if let sliderController = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.sliderController) as? UIViewController {
             
             if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                 if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                     sceneDelegate.window?.rootViewController = sliderController
                 }
             }
         }
    }
}

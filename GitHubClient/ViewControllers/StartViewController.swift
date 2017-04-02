//
//  StartViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    let gitManager = GitHubAPIManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.isConnectedToNetwork() {
            self.autoLogin()
        } else {
            print("No internet connection")
            self.showAlertWithTitle("No internet connection", andMessage: "Please check you internet connection and try again.")
        }
        
    }
    
    func autoLogin() -> Void {
        gitManager.oauth2.accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String
        if gitManager.oauth2.accessToken != nil {
            gitManager.oauth2.authConfig.authorizeContext = self
            gitManager.alamofireManager.request("https://api.github.com/user").validate().responseJSON { response in
                if let dict = response.result.value as? [String: Any] {
                    UserDefaults.standard.set(self.gitManager.oauth2.accessToken, forKey: "accessToken")
                    self.gitManager.user = User(dict)
                    print(self.gitManager.user!)
                    self.performSegue(withIdentifier: "startToTabBar", sender: nil)
                }
                else {
                    self.showAlertWithTitle("Login error", andMessage: "Sorry, can't get correct user info. Please use login form.")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        } else {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func showAlertWithTitle(_ title: String, andMessage message: String) -> Void {
        DispatchQueue.main.async {
            let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            allertController.addAction(action)
            self.present(allertController, animated: true, completion: nil)
        }
    }
    
}

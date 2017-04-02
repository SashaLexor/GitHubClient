//
//  LoginViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

import UIKit
import p2_OAuth2
import Alamofire


class LoginViewController: UIViewController {
    
    let gitManager = GitHubAPIManager.sharedInstance
    
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }
    
    @IBAction func loginButtonPresed(_ sender: UIButton) {
        if gitManager.oauth2.isAuthorizing {
            gitManager.oauth2.abortAuthorization()
            return
        }
        gitManager.loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                // save token here
                UserDefaults.standard.set(self.gitManager.oauth2.accessToken, forKey: "accessToken")
                self.gitManager.user = User(json)
                self.performSegue(withIdentifier: "loginToTabBar", sender: nil)
            }
            catch let error {
                print(error)
                self.showAlertWithTitle("Login error", andMessage: "Sorry, can't get correct user info. Please try again.")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gitManager.oauth2.authConfig.authorizeContext = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

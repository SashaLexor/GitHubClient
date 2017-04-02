//
//  EditProfileTableViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var blogTextField: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    let gitManager = GitHubAPIManager.sharedInstance
    
    
    // MARK: - IBAction Methods
    
    @IBAction func cancelButtonPresed(_ sender: UIBarButtonItem) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPresed(_ sender: UIBarButtonItem) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
        
        if let str = self.generateRequestBodyString() {
            gitManager.alamofireManager.request("https://api.github.com/user", method: .patch, parameters: [:], encoding: str, headers: nil).validate().responseJSON { response in
                print(response)
                if let dict = response.result.value as? [String: Any] {
                    self.gitManager.user = User(dict)
                    DispatchQueue.main.async {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
                else {
                    self.showAlertWithTitle("Save error", andMessage: "Sorry, can't save user info. Please try again.")
                }            
            }
        } else {
            self.showAlertWithTitle("Not correct data", andMessage: "Sorry, we can't save user info. Please check fields.")
        }
    }
    

    // MARK: - ViewContriller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Delegates Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Custom Methods
    
    func setupUI() -> Void {
        nameTextField.text = gitManager.user?.name ?? ""
        emailTextField.text = gitManager.user?.email ?? ""
        companyTextField.text = gitManager.user?.company ?? ""
        locationTextField.text = gitManager.user?.location ?? ""
        blogTextField.text = gitManager.user?.blogURL ?? ""
        bioTextView.text = gitManager.user?.bio ?? ""
    }
    
    func generateRequestBodyString() -> String? {
        
        var dict = [String:Any]()
        
        if nameTextField.text != gitManager.user?.name && nameTextField.text != "" {
            dict["name"] = nameTextField.text!
        }
        
        if emailTextField.text != gitManager.user?.email && emailTextField.text != "" {
            dict["email"] = emailTextField.text!
        }
        
        if companyTextField.text != gitManager.user?.company && companyTextField.text != "" {
            dict["company"] = companyTextField.text!
        }
        
        if locationTextField.text != gitManager.user?.location && locationTextField.text != "" {
            dict["location"] = locationTextField.text!
        }
        
        if blogTextField.text != gitManager.user?.blogURL && blogTextField.text != "" {
            dict["blog"] = blogTextField.text!
        }
        
        if bioTextView.text != gitManager.user?.bio && bioTextView.text != "" {
            dict["bio"] = bioTextView.text!
        }
        
        let json = JSON(dict)
        return json.rawString()
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

//
//  UserIinfoViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Alamofire

class UserIinfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let gitManager = GitHubAPIManager.sharedInstance
    var user: User! = nil
    
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.updateUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell") as! ProfileBasicTableViewCell
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.setTitle("Login:", andValue: user.login ?? "No login info")
            case 1:
                cell.setTitle("Company:", andValue: user.company ?? "No company info")
            case 2:
                cell.setTitle("Location:", andValue: user.location ?? "No location info")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.setTitle("Puplic Gists:", andValue: "\(user.public_gists?.stringValue ?? "No info")")
            case 1:
                cell.setTitle("Puplic Repositories:", andValue: "\(user.public_repos?.stringValue ?? "No info")")
            case 2:
                cell.setTitle("Followers:", andValue: "\(user.followers?.stringValue ?? "No info")")
            case 3:
                cell.setTitle("Following:", andValue: "\(user.following?.stringValue ?? "No info")")
            default:
                break
            }
        default:
              return cell
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Repositories & gists info"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 200
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let profileHeader =  ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
            let avaURL = URL(string: (user.avatar_url)!)
            profileHeader.setupHeaderWithAvaURL(avaURL, userName: user.name ?? "No name info", userEmail: user.email ?? "No public email")
            return profileHeader
        } else {
            return nil
        }
    }
    
    
    // MARK: - Custom Methods
    
    func setupTableView() -> Void {
        let basicCellNib = UINib(nibName: "ProfileBasicTableViewCell", bundle: nil)
        tableView.register(basicCellNib, forCellReuseIdentifier: "basicCell")
    }
    
    func updateUserInfo() -> Void {
        guard let userLogin = user.login else {
            return
        }
        gitManager.alamofireManager.request("https://api.github.com/users/\(userLogin)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if let userDict = response.value as? [String : Any] {
                self.user = User(userDict)
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("User info error", andMessage: "Can't update user info.")
            }
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

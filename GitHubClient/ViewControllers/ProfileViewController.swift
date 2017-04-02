//
//  ProfileViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Alamofire


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let gitManager = GitHubAPIManager.sharedInstance
    var privateGistsArray = [Gist]()
    var allPrivateReposArray = [Repository]()
    var ownedPrivateReposArray = [Repository]()
    
    
    @IBAction func editButtomPresed(_ sender: UIBarButtonItem) {
        print("Edit")
        self.performSegue(withIdentifier: "editProfileSegue", sender: nil)
    }
    
    @IBAction func logOutButtonPresed(_ sender: UIBarButtonItem) {
        self.logout()
    }
    
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.getAllGists()
        self.getAllPrivateRepos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell") as! ProfileBasicTableViewCell
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.setTitle("Login:", andValue: gitManager.user?.login ?? "No login")
            case 1:
                cell.setTitle("Company:", andValue: gitManager.user?.company ?? "No company")
            case 2:
                cell.setTitle("Location:", andValue: gitManager.user?.location ?? "No location")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.setTitle("Private Gists:", andValue: "\(privateGistsArray.count)")
            case 1:
                cell.setTitle("Total Public Repositories:", andValue: "\(gitManager.user?.public_repos?.stringValue ?? "No info")")
            case 2:
                cell.setTitle("Total Private Repositores:", andValue: "\(allPrivateReposArray.count)")
            case 3:
                cell.setTitle("Owned Private Repositores:", andValue: "\(ownedPrivateReposArray.count)")
            default:
                break
            }
        default:
            let repoCell = UITableViewCell(style: .default, reuseIdentifier: "allRepositories")
            repoCell.textLabel?.text = "All repositories"
            repoCell.accessoryType = .disclosureIndicator
            return repoCell
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
            let avaURL = URL(string: (gitManager.user?.avatar_url)!)
            profileHeader.setupHeaderWithAvaURL(avaURL, userName: gitManager.user?.name ?? "No name", userEmail: gitManager.user?.email ?? "No email")
            return profileHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            self.performSegue(withIdentifier: "allRepoSegue", sender: nil)
        }
    }
    
    
    // MARK: - Custom Methods
    
    func setupTableView() -> Void {
        let basicCellNib = UINib(nibName: "ProfileBasicTableViewCell", bundle: nil)
        tableView.register(basicCellNib, forCellReuseIdentifier: "basicCell")
    }
    
    func getAllGists() -> Void {
        guard let gistURLString = gitManager.user?.gists_url else {
            return
        }
        guard let gistURL = URL(string: gistURLString) else {
            return
        }
        gitManager.alamofireManager.request(gistURL).validate().responseJSON { response in
            if let dictArray = response.result.value as? [[String: Any]] {
                for dict in dictArray {
                    let gist = Gist(dict)
                    if !gist.isPublic! {
                        self.privateGistsArray.append(gist)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getAllPrivateRepos() -> Void {
        gitManager.alamofireManager.request("https://api.github.com/user/repos", method: .get, parameters: ["type":"private"], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if let repos = response.value as? [[String : Any]] {
                for repoDict in repos {
                    let repo = Repository(repoDict)
                    self.allPrivateReposArray.append(repo)
                }
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("Private repository error", andMessage: "Can't get repository list")
            }
        }
    }
    
    func getOwnedPrivateRepos() -> Void {
        gitManager.alamofireManager.request("https://api.github.com/user/repos", method: .get, parameters: ["type":"owner"], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if let repos = response.value as? [[String : Any]] {
                for repoDict in repos {
                    let repo = Repository(repoDict)
                    if repo.isPrivate! {
                        self.ownedPrivateReposArray.append(repo)
                    }
                }
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("Private repository error", andMessage: "Can't get repository list")
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
    
    func logout() {
        DispatchQueue.main.async {
            self.gitManager.oauth2.forgetTokens()
            self.gitManager.user = nil
            UserDefaults.standard.removeObject(forKey: "accessToken")
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func test() -> Void {
        gitManager.alamofireManager.request("https://api.github.com/user", method: .patch, parameters: [:], encoding: "{\"name\":\"Nerw\"}", headers: nil).validate().responseJSON { response in
            print(response)
        
        }

    }



}




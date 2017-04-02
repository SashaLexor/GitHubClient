//
//  UsersViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Alamofire

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let gitManager = GitHubAPIManager.sharedInstance
    var usersArray = [User]()
    let refreshControl = UIRefreshControl()
    var tableInSearchMode = false
    let perPageCount = 20
    var needMoreUsers = true
    
    @IBAction func searchButtonPresed(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.isHidden = !self.searchBar.isHidden
        })
    }
    
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.getUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userInfoSegue" {
            let indexPath = sender as! IndexPath
            let user = usersArray[indexPath.row]
            let userInfoVC = segue.destination as! UserIinfoViewController
            userInfoVC.user = user
        }
    }
    
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableInSearchMode || !needMoreUsers || usersArray.isEmpty {
            return usersArray.count
        } else {
            return usersArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < usersArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
            cell.configureWithUser(usersArray[indexPath.row])
            return cell
        } else {
            let loadCell = tableView.dequeueReusableCell(withIdentifier: "loadCell") as! LoadMoreTableViewCell
            return loadCell
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == usersArray.count {
            self.getUsers()
        } else {
            self.performSegue(withIdentifier: "userInfoSegue", sender: indexPath)
        }
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        usersArray = [User]()
        tableInSearchMode = true        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        self.searchUserWithQuery(query)
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - Custom Methods
    
    func setupTableView() -> Void {
        let userCellNib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(userCellNib, forCellReuseIdentifier: "userCell")
        
        let loadMoreCell = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadMoreCell, forCellReuseIdentifier: "loadCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to reload users list", attributes: [NSForegroundColorAttributeName:UIColor.white])
        refreshControl.backgroundColor = UIColor.customBlue
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func getUsers() -> Void {
        let lastUserId = usersArray.last?.userID?.stringValue ?? "0"
        gitManager.alamofireManager.request("https://api.github.com/users", method: .get, parameters: ["since" : lastUserId, "per_page" : "\(perPageCount)"], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if let users = response.value as? [[String : Any]] {
                if users.count < self.perPageCount {
                    self.needMoreUsers = false
                }
                for userDict in users {
                    let user = User(userDict)
                    self.usersArray.append(user)
                }
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("Users error", andMessage: "Can't get users list")
            }
        }
    }
    
    func searchUserWithQuery(_ query: String) -> Void {
        gitManager.alamofireManager.request("https://api.github.com/search/users", method: .get, parameters: ["q" : query], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            guard let dictResponse = response.value as? [String : Any] else {
                self.showAlertWithTitle("Search users error", andMessage: "Can't search users, please try again")
                return
            }
            
            guard let items = dictResponse["items"] as? [[String : Any]] else {
                self.showAlertWithTitle("Search users error", andMessage: "Can't search users, please try again")
                return
            }
            for userDict in items {
                let user = User(userDict)
                self.usersArray.append(user)
            }
            self.tableView.reloadData()
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
    
    func refresh() -> Void {
        usersArray = [User]()
        self.getUsers()
        self.refreshControl.endRefreshing()
        tableInSearchMode = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.resignFirstResponder()
                self.searchBar.isHidden = true
            })
        }
    }
    
    
}

//
//  AllRepositoriesViewController.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import Alamofire

class AllRepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let gitManager = GitHubAPIManager.sharedInstance
    let refreshControl = UIRefreshControl()
    var repoArray = [Repository]()
    let perPageCount = 10
    var pageNumber = 1
    var needMoreRepo = true
    

    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getRepos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView Delegate & Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !needMoreRepo || repoArray.isEmpty {
            return repoArray.count
        } else {
            return repoArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < repoArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoTableViewCell
            cell.selectionStyle = .none
            cell.configureWithRepo(self.repoArray[indexPath.row])
            return cell
        } else {
            let loadCell = tableView.dequeueReusableCell(withIdentifier: "loadCell") as! LoadMoreTableViewCell
            return loadCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.getRepos()
    }
    
    
    // MARK: - Custom Methods
    
    func getRepos() -> Void {
        gitManager.alamofireManager.request("https://api.github.com/user/repos", method: .get, parameters: ["per_page" : "\(perPageCount)", "page" : "\(pageNumber)"], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if let repos = response.value as? [[String : Any]] {
                if repos.count < self.perPageCount {
                    self.needMoreRepo = false
                }
                
                for repoDict in repos {
                    let repo = Repository(repoDict)
                    self.repoArray.append(repo)
                }
                self.pageNumber += 1
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("Repository error", andMessage: "Can't get repository list")
            }
        }
    }
    
    func setupTableView() -> Void {
        let nib = UINib(nibName: "RepoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "repoCell")
        
        let loadMoreCell = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadMoreCell, forCellReuseIdentifier: "loadCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to reload users list", attributes: [NSForegroundColorAttributeName:UIColor.white])
        refreshControl.backgroundColor = UIColor.customBlue
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func refresh() -> Void {
        repoArray = [Repository]()
        pageNumber = 1
        self.needMoreRepo = true
        self.getRepos()
        self.refreshControl.endRefreshing()
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

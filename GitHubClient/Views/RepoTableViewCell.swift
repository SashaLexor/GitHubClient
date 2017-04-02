//
//  RepoTableViewCell.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithRepo(_ repo: Repository) {
        repoNameLabel.text = repo.name ?? "No repository name"
        authorLabel.text = (repo.owner?["login"] as? String) ?? ""
        descriptionLabel.text = repo.repoDescription ?? ""
        lastUpdateLabel.text = repo.updated_at ?? ""
        if let date = repo.date {
            lastUpdateLabel.text = dateFormatter.string(from: date)
        }
        privateLabel.text = (repo.isPrivate ?? false) ? "Private" : "Public"
    }

    
}

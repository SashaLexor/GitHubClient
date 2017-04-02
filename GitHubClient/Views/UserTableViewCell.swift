//
//  UserTableViewCell.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvaImageView: UIImageView!
    @IBOutlet weak var userNamaLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureWithUser(_ user: User) {
        userAvaImageView.layer.cornerRadius = userAvaImageView.bounds.size.width / 2
        userAvaImageView.layer.borderColor = UIColor.customBlue.cgColor
        userAvaImageView.layer.borderWidth = 2
        if let avaURLString = user.avatar_url, let avaURL = URL(string:avaURLString) {
            userAvaImageView.af_setImage(withURL: avaURL)
        }
        userNamaLabel.text = user.login ?? "No login"
    }
}

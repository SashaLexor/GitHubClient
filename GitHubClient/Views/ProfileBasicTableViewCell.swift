//
//  ProfileBasicTableViewCell.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class ProfileBasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(_ title: String, andValue value: String) -> Void {
        titleLabel.text = title
        valueLabel.text = value
    }
    
}

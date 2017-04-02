//
//  ProfileTableViewHeader.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileTableViewHeader: UIView {
    
    
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupHeaderWithAvaURL(_ url: URL?, userName name: String, userEmail email: String) -> Void {
        if url != nil {
            avaImageView.af_setImage(withURL: url!)
        }
        userNameLabel.text = name
        userEmailLabel.text = email
        avaImageView.layer.cornerRadius = avaImageView.bounds.size.width / 2
        avaImageView.layer.borderWidth = 2
        avaImageView.layer.borderColor = UIColor.customBlue.cgColor
    }
    
}

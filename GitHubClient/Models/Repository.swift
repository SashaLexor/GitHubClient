//
//  Repository.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class Repository: NSObject {
    
    var name: String?
    var full_name: String?
    var owner: [String : Any]?
    var repoDescription: String?
    var updated_at: String?
    var commits_url: String?
    var date: Date?
    var isPrivate: Bool?
    
    override var description: String {
        return "NAME:\(name)\nFULL NAME: \(full_name)\nOWNER: \(owner)\n DESCRIPTION: \(repoDescription)\nUPDATED AT:\(updated_at) \n\n\n"
    }
    
    let updatedDate: Date? = nil
    
    convenience init(_ dictionary: [String : Any]) {
        self.init()
        name = dictionary["name"] as? String
        full_name = dictionary["full_name"] as? String
        owner = dictionary["owner"] as? [String : Any]
        repoDescription = dictionary["description"] as? String
        
        if let commitsURL =  dictionary["commits_url"] as? String {
            commits_url = commitsURL.components(separatedBy: "{").first
        }
        
        updated_at = dictionary["updated_at"] as! String?
        
        if let strTime = updated_at {
            if #available(iOS 10.0, *) {
                let isoFormatter = ISO8601DateFormatter()
                date = isoFormatter.date(from: strTime)!
            } else {
                // Fallback on earlier versions
            }
        }
        
        isPrivate = (dictionary["private"] as? NSNumber)?.boolValue
    }
}

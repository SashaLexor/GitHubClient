//
//  User.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String?
    var email: String?
    var avatar_url: String?
    var repos_url: String?
    var login: String?
    var company: String?
    var location: String?
    var gists_url: String?
    var userID: NSNumber?
    var public_gists: NSNumber?
    var public_repos: NSNumber?
    var followers: NSNumber?
    var following: NSNumber?
    var blogURL: String?
    var bio: String?
    
    override var description: String {
        return "NAME:\(name) EMAIL: \(email) AVAURL: \(avatar_url)  REPOSURL: \(repos_url)"
    }
    
    
    convenience init(_ dictionary: [String : Any]) {
        self.init()
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        avatar_url = dictionary["avatar_url"] as? String
        repos_url = dictionary["repos_url"] as? String
        login = dictionary["login"] as? String
        company = dictionary["company"] as? String
        location = dictionary["location"] as? String
        gists_url = (dictionary["gists_url"] as? String)?.components(separatedBy: "{").first
        userID = dictionary["id"] as? NSNumber
        public_gists = dictionary["public_gists"] as? NSNumber
        public_repos = dictionary["public_repos"] as? NSNumber
        followers = dictionary["followers"] as? NSNumber
        following = dictionary["following"] as? NSNumber
        blogURL = dictionary["blog"] as? String
        bio = dictionary["bio"] as? String
    }
}

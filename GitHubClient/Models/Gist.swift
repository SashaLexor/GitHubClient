//
//  Gist.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation

class Gist: NSObject {
    
    var gistDescription: String?
    var isPublic: Bool?

    convenience init(_ dictionary: [String : Any]) {
        self.init()
        gistDescription = dictionary["description"] as? String
        isPublic = (dictionary["public"] as? NSNumber)?.boolValue
    }
}

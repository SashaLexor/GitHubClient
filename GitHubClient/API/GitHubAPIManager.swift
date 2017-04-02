//
//  GitHubAPIManager.swift
//  GitHubClient
//
//  Created by Alex on 4/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire


class GitHubAPIManager: NSObject {
    
    static let sharedInstance: GitHubAPIManager = GitHubAPIManager()
    
    let oauth2: OAuth2CodeGrant
    let loader: OAuth2DataLoader
    let alamofireManager: SessionManager
    
    var user: User?
    
    private override init() {
        
        
        
        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": "94d578278bb665df6d28",                           // My app id & secret
            "client_secret": "a9de44bdffdecfbc666db562e4ccabedb127e4ba",
            "authorize_uri": "https://github.com/login/oauth/authorize",
            "token_uri": "https://github.com/login/oauth/access_token",
            "scope": "user, repo:status, gist",
            "redirect_uris": ["myapp://oauth/callback"],            // app has registered this scheme
            "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
            "verbose": true,
            ] as OAuth2JSON)
        
        oauth2.authConfig.authorizeEmbedded = true
        
        loader = OAuth2DataLoader(oauth2: oauth2)
        
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        alamofireManager = sessionManager
        
        super.init()
    }
    
    
}

//
//  ParameterEncodingStringExtention.swift
//  GitHubClient
//
//  Created by Alex on 4/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

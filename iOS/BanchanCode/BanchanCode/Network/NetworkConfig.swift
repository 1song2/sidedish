//
//  NetworkConfig.swift
//  BanchanCode
//
//  Created by Song on 2021/10/11.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    
     public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

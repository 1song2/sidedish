//
//  NetworkConfig.swift
//  BanchanCode
//
//  Created by Song on 2021/10/11.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL? { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL?
    
    init(baseURL: URL?) {
        self.baseURL = baseURL
    }
}

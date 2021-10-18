//
//  Endpoint.swift
//  BanchanCode
//
//  Created by Song on 2021/10/11.
//

import Foundation
import Alamofire

class Endpoint<R>: ResponseRequestable {
    typealias Response = R
    
    let path: String
    let method: HTTPMethod
    
    init(path: String,
         method: HTTPMethod) {
        self.path = path
        self.method = method
    }
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    
    func fullPath(with config: NetworkConfigurable) -> String
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

extension Requestable {
    func fullPath(with config: NetworkConfigurable) -> String {
        if let baseURL = config.baseURL {
            let baseURLStr = baseURL.absoluteString.last != "/"
            ? baseURL.absoluteString + "/"
            : baseURL.absoluteString
            return baseURLStr.appending(path)
        } else {
            return path
        }
    }
}

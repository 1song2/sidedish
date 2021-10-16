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
    let isFullPath: Bool
    let method: HTTPMethod
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
    }
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    
    func fullPath(with config: NetworkConfigurable) -> String
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

extension Requestable {
    func fullPath(with config: NetworkConfigurable) -> String {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        return isFullPath ? path : baseURL.appending(path)
    }
}

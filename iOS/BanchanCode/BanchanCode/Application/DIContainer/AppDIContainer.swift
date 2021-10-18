//
//  AppDIContainer.swift
//  BanchanCode
//
//  Created by Song on 2021/10/17.
//

import Foundation
import Alamofire

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    let concurrentQueue = DispatchQueue(label: "com.song.decodeQueue", attributes: .concurrent)
    
    // MARK: - Network
    lazy var apiNetworkService: NetworkService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        return DefaultNetworkService(config: config,
                                     session: AF,
                                     queue: concurrentQueue)
    }()
    lazy var imageNetworkService: NetworkService = {
        let config = ApiDataNetworkConfig(baseURL: nil)
        return DefaultNetworkService(config: config,
                                     session: AF,
                                     queue: concurrentQueue)
    }()
    
    // MARK: - DIContainers of scenes
    func makeDishesSceneDIContainer() -> DishesSceneDIContainer {
        let dependencies = DishesSceneDIContainer.Dependencies(apiNetworkService: apiNetworkService,
                                                               imageNetworkService: imageNetworkService)
        return DishesSceneDIContainer(dependencies: dependencies)
    }
}

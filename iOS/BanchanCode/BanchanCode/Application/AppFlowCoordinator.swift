//
//  AppFlowCoordinator.swift
//  BanchanCode
//
//  Created by Song on 2021/10/18.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let dishesSceneDIContainer = appDIContainer.makeDishesSceneDIContainer()
        let flow = dishesSceneDIContainer.makeDishSelectionFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}

//
//  SceneDelegate.swift
//  BanchanCode
//
//  Created by jinseo park on 4/20/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDICotainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Unable to Instantiate Initial View Controller")
        }
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController,
                                                appDIContainer: appDICotainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}

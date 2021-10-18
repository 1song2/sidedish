//
//  DishSelectionFlowCoordinator.swift
//  BanchanCode
//
//  Created by Song on 2021/10/17.
//

import UIKit

protocol DishSelectionFlowCoordinatorDependencies  {
    func inject(categories: [CategoryViewModel], to viewController: MainPageViewController?)
    func makeDishDetailsViewController(dish: Dish) -> DetailPageViewController
    func makeCategoryViewModel(actions: CategoryViewModelActions, sectionIndex: Int, path: String, phrase: String) -> CategoryViewModel
}

final class DishSelectionFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: DishSelectionFlowCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: DishSelectionFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = CategoryViewModelActions(showDishDetails: showDishDetails)
        let mainCategoryViewModel = dependencies.makeCategoryViewModel(actions: actions,
                                                                       sectionIndex: 0,
                                                                       path: "main",
                                                                       phrase: "모두가 좋아하는 든든한 메인요리")
        let soupCategoryViewModel = dependencies.makeCategoryViewModel(actions: actions,
                                                                       sectionIndex: 1,
                                                                       path: "soup",
                                                                       phrase: "정성이 담긴 뜨끈뜨끈 국물요리")
        let sideCategoryViewModel = dependencies.makeCategoryViewModel(actions: actions,
                                                                       sectionIndex: 2,
                                                                       path: "side",
                                                                       phrase: "식탁을 풍성하게 하는 정갈한 밑반찬")
        let categories = [mainCategoryViewModel, soupCategoryViewModel, sideCategoryViewModel]
        
        let rootViewController = navigationController?.viewControllers.first as? MainPageViewController
        dependencies.inject(categories: categories, to: rootViewController)
    }
    
    private func showDishDetails(dish: Dish) {
        let vc = dependencies.makeDishDetailsViewController(dish: dish)
        navigationController?.pushViewController(vc, animated: true)
    }
}

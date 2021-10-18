//
//  DishesSceneDIContainer.swift
//  BanchanCode
//
//  Created by Song on 2021/10/17.
//

import Foundation
import UIKit

final class DishesSceneDIContainer {
    struct Dependencies {
        let apiNetworkService: NetworkService
        let imageNetworkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    //lazy var dishesResponseCache: DishesResponseStorage = CoreDataDishesResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeDishesRepository() -> DishesRepository {
        return DefaultDishesRepository(networkService: dependencies.apiNetworkService)
    }
    func makeDishDetailsRepository() -> DishDetailsRepository {
        return DefaultDishDetailsRepository(networkService: dependencies.apiNetworkService)
    }
    func makeDishImagesRepository() -> DishImagesRepository {
        return DefaultDishImagesRepository(networkService: dependencies.imageNetworkService)
    }
    
    // MARK: - Dishes
    func inject(categories: [CategoryViewModel], to viewController: MainPageViewController?) {
        viewController?.inject(viewModel: makeDishesViewModel(categories: categories), dishImagesRepository: makeDishImagesRepository())
    }
    
    func makeDishesViewModel(categories: [CategoryViewModel]) -> DishesViewModel {
        return DefaultDishesViewModel(categories: categories)
    }
    
    func makeCategoryViewModel(actions: CategoryViewModelActions, sectionIndex: Int, path: String, phrase: String) -> CategoryViewModel {
        return DefaultCategoryViewModel(dishesRepository: makeDishesRepository(),
                                        actions: actions,
                                        sectionIndex: sectionIndex,
                                        path: path,
                                        phrase: phrase)
    }
    
    // MARK: - Dish Details
    func makeDishDetailsViewController(dish: Dish) -> DetailPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "detailPageVC") { [weak self] coder in
            DetailPageViewController(coder: coder, viewModel: self?.makeDishDetailsViewModel(dish: dish))
        }
    }
    
    func makeDishDetailsViewModel(dish: Dish) -> DishDetailsViewModel {
        return DefaultDishDetailsViewModel(dish: dish,
                                           dishDetailsRepository: makeDishDetailsRepository(),
                                           dishImageRepository: makeDishImagesRepository())
    }
    
    // MARK: - Flow Coordinators
    func makeDishSelectionFlowCoordinator(navigationController: UINavigationController) -> DishSelectionFlowCoordinator {
        return DishSelectionFlowCoordinator(navigationController: navigationController,
                                            dependencies: self)
    }
}

extension DishesSceneDIContainer: DishSelectionFlowCoordinatorDependencies { }

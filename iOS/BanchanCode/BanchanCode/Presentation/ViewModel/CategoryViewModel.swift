//
//  CategoryViewModel.swift
//  BanchanCode
//
//  Created by Song on 2021/10/16.
//

import Foundation

struct CategoryViewModelActions {
    let showDishDetails: (Dish) -> Void
}

protocol CategoryViewModelInput {
    func load(completion: @escaping (Int, Dishes) -> Void)
    func getNumberOfItems() -> Int
    func didSelectItem(at index: Int)
    func update(items: Dishes)
}

protocol CategoryViewModelOutput {
    var sectionIndex: Int { get }
    var path: String { get }
    var phrase: String { get }
    var items: Observable<[DishesItemViewModel]> { get }
}

protocol CategoryViewModel: CategoryViewModelInput, CategoryViewModelOutput { }

final class DefaultCategoryViewModel: CategoryViewModel {
    private let dishesRepository: DishesRepository
    private let actions: CategoryViewModelActions?
    
    //MARK: - Output
    var sectionIndex: Int
    var path: String
    var phrase: String
    var items: Observable<[DishesItemViewModel]> = Observable([])
    
    //MARK: - Init
    init(dishesRepository: DishesRepository,
         actions: CategoryViewModelActions? = nil,
         sectionIndex: Int,
         path: String,
         phrase: String) {
        self.dishesRepository = dishesRepository
        self.sectionIndex = sectionIndex
        self.path = path
        self.phrase = phrase
        self.actions = actions
    }
    
    func load(completion: @escaping (Int, Dishes) -> Void) {
        dishesRepository.fetchDishes(category: path) { result in
            switch result {
            case .success(let items):
                completion(self.sectionIndex, items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        return items.value.count
    }
    
    func didSelectItem(at index: Int) {
        actions?.showDishDetails(items.value[index].dish)
    }
    
    func update(items: Dishes) {
        self.items.value = items.dishes.map(DishesItemViewModel.init)
    }
}

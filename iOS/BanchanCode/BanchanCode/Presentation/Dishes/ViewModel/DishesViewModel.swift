//
//  DishesListViewModel.swift
//  BanchanCode
//
//  Created by Song on 2021/04/23.
//

import Foundation

protocol DishesViewModelInput {
    func load(completion: @escaping (Int, Dishes) -> Void)
    func update(index: Int, items: Dishes)
}

protocol DishesViewModelOutput {
    var categories: [CategoryViewModel] { get }
}

protocol DishesViewModel: DishesViewModelInput, DishesViewModelOutput { }

final class DefaultDishesViewModel: DishesViewModel {
    //MARK: - Output
    var categories: [CategoryViewModel] = []
    
    //MARK: - Init
    init(categories: [CategoryViewModel]) {
        self.categories = categories
    }
}

//MARK: - Input
extension DefaultDishesViewModel {
    func load(completion: @escaping (Int, Dishes) -> Void) {
        categories.forEach { categoryViewModel in
            categoryViewModel.load { index, items in
                completion(index, items)
            }
        }
    }
    
    func update(index: Int, items: Dishes) {
        self.categories[index].update(items: items)
    }
}

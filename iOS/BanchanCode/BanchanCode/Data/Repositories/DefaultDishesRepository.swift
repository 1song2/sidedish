//
//  DefaultDishesRepository.swift
//  BanchanCode
//
//  Created by Song on 2021/10/16.
//

import Foundation

protocol DishesRepository {
    func fetchDishes(category: String,
                     completion: @escaping (Result<Dishes, Error>) -> Void)
}

final class DefaultDishesRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDishesRepository: DishesRepository {
    func fetchDishes(category: String,
                     completion: @escaping (Result<Dishes, Error>) -> Void) {
        let endpoint = APIEndpoints.getDishes(of: category)
        networkService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case . failure(let error):
                completion(.failure(error))
                //completion(.success(self.realmManager.getDishes(categryName: categoryName)))
            }
        }
    }
}

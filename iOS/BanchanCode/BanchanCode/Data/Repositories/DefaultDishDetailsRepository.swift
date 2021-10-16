//
//  DefaultDishDetailsRepository.swift
//  BanchanCode
//
//  Created by Song on 2021/10/16.
//

import Foundation

protocol DishDetailsRepository {
    func fetchDishDetails(hash: String,
                          completion: @escaping (Result<DishDetail, Error>) -> Void)
}

final class DefaultDishDetailsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDishDetailsRepository: DishDetailsRepository {
    func fetchDishDetails(hash: String,
                          completion: @escaping (Result<DishDetail, Error>) -> Void) {
        let endpoint = APIEndpoints.getDishDetails(path: "detail/\(hash)")
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

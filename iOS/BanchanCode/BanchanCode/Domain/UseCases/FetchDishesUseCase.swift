//
//  FetchDishesUseCase.swift
//  BanchanCode
//
//  Created by Song on 2021/04/25.
//

import Foundation

protocol FetchDishesUseCase {
    func execute(requestValue: FetchDishesUseCaseRequestValue,
                 completion: @escaping (Result<Dishes, Error>) -> Void)
}

final class DefaultFetchDishesUseCase: FetchDishesUseCase {
    let networkManager = NetworkManager()
    let realmManager = RealmManager()
    
    func execute(requestValue: FetchDishesUseCaseRequestValue,
                 completion: @escaping (Result<Dishes, Error>) -> Void) {
        return fetchDishes(categoryName: requestValue.categoryName, completion: { result in
            switch result {
            case .success(let responseDTO):
                self.realmManager.addDishes(dishesItem: responseDTO.dishes.map(DishesItemViewModel.init), categoryName: requestValue.categoryName)
            case .failure:
                break
            }
            completion(result)
        })
    }
    
    private func fetchDishes(categoryName: String,
                             completion: @escaping (Result<Dishes, Error>) -> Void) {
        let url = "http://ec2-3-36-241-44.ap-northeast-2.compute.amazonaws.com:8080/banchan-code/\(categoryName)"
        //        let url = "httpadad://ec2-3-36-241-44.ap-northeast-2.compute.amazonaws.com:8080/banchan-code/\(categoryName)"
        
        networkManager.performRequest(urlString: url) { (responseDTO: DishesResponseDTO) in
            completion(.success(responseDTO.toDomain()))
        }
        
    }
}

struct FetchDishesUseCaseRequestValue {
    let categoryName: String
}

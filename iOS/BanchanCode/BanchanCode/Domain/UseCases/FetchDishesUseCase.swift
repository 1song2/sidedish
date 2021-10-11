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
    //let realmManager = RealmManager()
    
    func execute(requestValue: FetchDishesUseCaseRequestValue,
                 completion: @escaping (Result<Dishes, Error>) -> Void) {
        return fetchDishes(categoryName: requestValue.categoryName, completion: { result in
            switch result {
            case .success(let response):
                //self.realmManager.addDishes(items: response.dishes.map(DishesItemViewModel.init), categoryName: requestValue.categoryName)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func fetchDishes(categoryName: String,
                             completion: @escaping (Result<Dishes, Error>) -> Void) {
        let url = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan/\(categoryName)"
        
        networkManager.performRequest(urlString: url) { (result : Result<DishesResponseDTO, Error>) in 
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(_):
                break
                //completion(.success(self.realmManager.getDishes(categryName: categoryName)))
            }
        }
    }
}

struct FetchDishesUseCaseRequestValue {
    let categoryName: String
}

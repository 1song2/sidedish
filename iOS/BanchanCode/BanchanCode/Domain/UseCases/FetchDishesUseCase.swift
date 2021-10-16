//
//  FetchDishesUseCase.swift
//  BanchanCode
//
//  Created by Song on 2021/04/25.
//

import Foundation
import Alamofire

protocol FetchDishesUseCase {
    func execute(requestValue: FetchDishesUseCaseRequestValue,
                 completion: @escaping (Result<Dishes, Error>) -> Void)
}

final class DefaultFetchDishesUseCase: FetchDishesUseCase {
    lazy var appConfiguration = AppConfiguration()
    lazy var config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
    lazy var concurrentQueue = DispatchQueue(label: "com.song.decodeQueue", attributes: .concurrent)
    lazy var networkService = DefaultNetworkService(config: config, session: AF, queue: concurrentQueue)
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
        
        networkService.request(with: url) { (result : Result<DishesResponseDTO, Error>) in 
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

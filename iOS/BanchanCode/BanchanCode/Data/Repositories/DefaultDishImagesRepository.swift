//
//  DefaultDishImageRepository.swift
//  BanchanCode
//
//  Created by Song on 2021/10/16.
//

import Foundation

protocol DishImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultDishImagesRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDishImagesRepository: DishImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let endpoint = APIEndpoints.getImage(path: imagePath)
        networkService.request(with: endpoint) { (result: Result<Data, Error>) in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
    }
}

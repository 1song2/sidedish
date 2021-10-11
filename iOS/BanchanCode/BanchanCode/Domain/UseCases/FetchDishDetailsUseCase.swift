//
//  FetchDishDetailsUseCase.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import Foundation

final class FetchDishDetailsUseCase: UseCase {
    let networkManager = NetworkManager()
    struct RequestValue {
        let categoryName: String
        let id: Int
    }
    typealias ResultValue = (Result<DishDetail, Error>)
    
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    
    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void) {
        self.requestValue = requestValue
        self.completion = completion
    }
    
    func start() {
        fetchDishDetails(categoryName: requestValue.categoryName, id: requestValue.id, completion: completion)
    }
    
    private func fetchDishDetails(hash: String, completion: @escaping (ResultValue) -> Void) {
        let url = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan/detail/\(hash)"
        
        networkManager.performRequest(urlString: url) { (result: Result<DishDetailResponseDTO, Error>) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

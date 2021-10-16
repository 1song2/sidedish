//
//  FetchDishDetailsUseCase.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import Foundation
import Alamofire

final class FetchDishDetailsUseCase: UseCase {
    lazy var appConfiguration = AppConfiguration()
    lazy var config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
    lazy var concurrentQueue = DispatchQueue(label: "com.song.decodeQueue", attributes: .concurrent)
    lazy var networkService = DefaultNetworkService(config: config, session: AF, queue: concurrentQueue)
    
    struct RequestValue {
        let hash: String
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
        fetchDishDetails(hash: requestValue.hash, completion: completion)
    }
    
    private func fetchDishDetails(hash: String, completion: @escaping (ResultValue) -> Void) {
        let url = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan/detail/\(hash)"
        
        networkService.request(with: url) { (result: Result<DishDetailResponseDTO, Error>) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

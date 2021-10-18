//
//  NetworkService.swift
//  BanchanCode
//
//  Created by Song on 2021/10/11.
//

import Foundation
import Alamofire

protocol NetworkService {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> DataRequest? where E.Response == T
    
    @discardableResult
    func request<E: ResponseRequestable>(with endpoint: E,
                                         completion: @escaping CompletionHandler<Data>) -> DataRequest? where E.Response == Data
}

protocol NetworkSession {
    typealias RequestModifier = (inout URLRequest) throws -> Void
    
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 encoding: ParameterEncoding,
                 headers: HTTPHeaders?,
                 interceptor: RequestInterceptor?,
                 requestModifier: RequestModifier?) -> DataRequest
}

extension Session: NetworkSession { }

// MARK: - Implementation
final class DefaultNetworkService: NetworkService {
    private let config: NetworkConfigurable
    private let session: NetworkSession
    private let queue: DispatchQueue
    
    init(config: NetworkConfigurable,
         session: NetworkSession,
         queue: DispatchQueue) {
        self.config = config
        self.session = session
        self.queue = queue
    }
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> DataRequest? where E.Response == T {
        let request = session.request(endpoint.fullPath(with: config),
                                      method: endpoint.method,
                                      parameters: nil,
                                      encoding: URLEncoding.default,
                                      headers: nil,
                                      interceptor: nil,
                                      requestModifier: nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self,
                               queue: queue) { response in
                switch response.result {
                case .success(let responseDTO):
                    completion(.success(responseDTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        return request
    }
    
    func request<E: ResponseRequestable>(with endpoint: E,
                                         completion: @escaping CompletionHandler<Data>) -> DataRequest? where E.Response == Data {
        let request = session.request(endpoint.fullPath(with: config),
                                      method: endpoint.method,
                                      parameters: nil,
                                      encoding: URLEncoding.default,
                                      headers: nil,
                                      interceptor: nil,
                                      requestModifier: nil)
            .validate(statusCode: 200..<300)
            .responseData(queue: queue) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        return request
    }
}

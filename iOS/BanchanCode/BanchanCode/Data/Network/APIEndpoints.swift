//
//  APIEndpoints.swift
//  BanchanCode
//
//  Created by Song on 2021/10/11.
//

import Foundation

struct APIEndpoints {
    static func getDishes(path: String) -> Endpoint<DishesResponseDTO> {
        return Endpoint(path: path,
                        method: .get)
    }
    
    static func getDishDetails(path: String) -> Endpoint<DishDetailResponseDTO> {
        return Endpoint(path: path,
                        method: .get)
    }

    static func getImage(path: String) -> Endpoint<Data> {
        return Endpoint(path: path,
                        isFullPath: true,
                        method: .get)
    }
}

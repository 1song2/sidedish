//
//  DishesResponseDTO+Mapping.swift
//  BanchanCode
//
//  Created by Song on 2021/04/22.
//

import Foundation

struct DishesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case dishes = "body"
    }
    let dishes: [DishDTO]
}

extension DishesResponseDTO {
    struct DishDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case hash = "detail_hash"
            case imageURL = "image"
            case deliveryMethod = "delivery_type"
            case title
            case description
            case originalPrice = "n_price"
            case lastPrice = "s_price"
            case badges = "badge"
        }
        let hash: String
        let imageURL: String
        let deliveryMethod: [String]
        let title: String
        let description: String
        let originalPrice: String?
        let lastPrice: String
        let badges: [String]?
    }
}

extension DishesResponseDTO {
    func toDomain() -> Dishes {
        return .init(dishes: dishes.map { $0.toDomain() })
    }
}

extension DishesResponseDTO.DishDTO {
    func toDomain() -> Dish {
        return .init(hash: hash,
                     imageURL: imageURL,
                     title: title,
                     description: description,
                     originalPrice: originalPrice,
                     lastPrice: lastPrice,
                     badges: badges)
    }
}

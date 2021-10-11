//
//  DishDetailResponseDTO.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import Foundation

struct DishDetailResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case data
    }
    let data: AdditionalInformationDTO
}

extension DishDetailResponseDTO {
    struct AdditionalInformationDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case thumbImages = "thumb_images"
            case point
            case deliveryMethod = "delivery_info"
            case deliveryFee = "delivery_fee"
            case detailImages = "detail_section"
        }
        let thumbImages: [String]
        let point: String
        let deliveryMethod: String
        let deliveryFee: String
        let detailImages: [String]
    }
}

extension DishDetailResponseDTO {
    func toDomain() -> DishDetail {
        return .init(additionalInformation: data.toDomain())
    }
}

extension DishDetailResponseDTO.AdditionalInformationDTO {
    func toDomain() -> AdditionalInformation {
        return .init(thumbImages: thumbImages,
                     point: point,
                     deliveryMethod: deliveryMethod,
                     deliveryFee: deliveryFee,
                     detailImages: detailImages)
    }
}

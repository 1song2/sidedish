//
//  DishDetail.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import Foundation

struct DishDetail {
    let additionalInformation: AdditionalInformation
}

struct AdditionalInformation {
    let thumbImages: [String]?
    let point: String?
    let deliveryMethod: String?
    let deliveryFee: String?
    let detailImages: [String]?
    
    init(thumbImages: [String]? = nil,
         point: String? = nil,
         deliveryMethod: String? = nil,
         deliveryFee: String? = nil,
         detailImages: [String]? = nil) {
        self.thumbImages = thumbImages
        self.point = point
        self.deliveryMethod = deliveryMethod
        self.deliveryFee = deliveryFee
        self.detailImages = detailImages
    }
}

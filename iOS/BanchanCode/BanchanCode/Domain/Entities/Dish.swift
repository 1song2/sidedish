//
//  Dish.swift
//  BanchanCode
//
//  Created by Song on 2021/04/21.
//

import Foundation

struct Dish{
    let hash: String
    let imageURL: String
    let title: String
    let description: String
    let originalPrice: String?
    let lastPrice: String
    let badges: [String]?
}

struct Dishes {
    var dishes: [Dish]
}

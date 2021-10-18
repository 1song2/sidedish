//
//  Int+commaRepresentation.swift
//  BanchanCode
//
//  Created by Song on 2021/10/17.
//

import Foundation

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var commaRepresentation: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

//
//  String+ExtractingNumberFromString.swift
//  BanchanCode
//
//  Created by Song on 2021/10/17.
//

import Foundation

extension String {
    var extractedNumbers: Int {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
}

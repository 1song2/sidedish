//
//  NSAttributedString+PartiallyBoldText.swift
//  BanchanCode
//
//  Created by Song on 2021/04/30.
//

import UIKit

extension NSAttributedString {
    convenience init(boldPart: String, in wholeString: String, fontSize: CGFloat) {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributedString = NSMutableAttributedString(string: wholeString,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (wholeString as NSString).range(of: boldPart)
        attributedString.addAttributes(boldFontAttribute, range: range)
        self.init(attributedString: attributedString)
    }
}

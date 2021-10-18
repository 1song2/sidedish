//
//  SectionHeaderView.swift
//  BanchanCode
//
//  Created by jinseo park on 4/21/21.
//

import UIKit
import Toaster

class SectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    private var viewModel: CategoryViewModel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showNumberOfItems(with: viewModel)
    }
    
    func fill(with viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        sectionTitleLabel.text = viewModel.phrase
    }
    
    private func showNumberOfItems(with viewModel: CategoryViewModel) {
        Toast(text: "\(viewModel.getNumberOfItems())개 상품이 등록되어 있습니다").show()
    }
}

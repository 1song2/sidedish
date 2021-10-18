//
//  DishCell.swift
//  BanchanCode
//
//  Created by Song on 2021/04/20.
//

import UIKit
import Alamofire

class DishCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var badgeStackView: UIStackView!
    
    static let reuseIdentifier = String(describing: DishCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.cornerRadius = 5.0
    }
    
    func fill(with viewModel: DishesItemViewModel, dishImageRepository: DishImagesRepository?) {
        let dish = viewModel.dish
        nameLabel.text = dish.title
        descriptionLabel.text = dish.description
        lastPriceLabel.text = dish.lastPrice
        configureOriginalPriceLabel(dish.originalPrice)
        configureBadgeStackView(dish.badges)
        updateThumbnailImage(imagePath: viewModel.dish.imageURL, repository: dishImageRepository)
    }
    
    private func configureOriginalPriceLabel(_ origialPrice: String?) {
        if let originalPrice = origialPrice {
            originalPriceLabel.attributedText = originalPrice.strikethrough()
            originalPriceLabel.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
        }
    }
    
    private func configureBadgeStackView(_ badges: [String]?) {
        badgeStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        if let badges = badges {
            badgeStackView.isHidden = false
            badges.forEach { badgeString in
                let badgeView = BadgeView()
                badgeView.fill(with: badgeString)
                badgeStackView.addArrangedSubview(badgeView)
            }
        } else {
            badgeStackView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
    }
    
    private func updateThumbnailImage(imagePath: String, repository: DishImagesRepository?) {
        repository?.fetchImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }
    }
}

//
//  DetailPageViewController.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import UIKit

class DetailPageViewController: UIViewController {
    @IBOutlet weak var thumbnailImagesScrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var badgeBackgroundView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var deliveryInfoLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var detailImagesStackView: UIStackView!
    
    var categoryName: String?
    var id: Int?
    var viewModel: DishDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = makeDishDetailsViewModel()
        bind(to: viewModel)
        
        viewModel.load()
        
        self.thumbnailImagesScrollView.isPagingEnabled = true
        badgeBackgroundView.layer.masksToBounds = true
        badgeBackgroundView.layer.cornerRadius = 5.0
        orderButton.layer.masksToBounds = true
        orderButton.layer.cornerRadius = 5.0
        totalPriceLabel.text = "0원"
    }
    
    func makeFetchDishDetailsUseCase(requestValue: FetchDishDetailsUseCase.RequestValue,
                                     completion: @escaping (FetchDishDetailsUseCase.ResultValue) -> Void) -> UseCase {
        return FetchDishDetailsUseCase(requestValue: requestValue,
                                       completion: completion)
    }
    
    func makeDishDetailsViewModel() -> DishDetailsViewModel? {
        guard let categoryName = categoryName else { return nil }
        guard let id = id else { return nil }
        return DefaultDishDetailsViewModel(fetchDishDetailsUseCaseFactory: makeFetchDishDetailsUseCase,
                                           categoryName: categoryName,
                                           id: id)
    }
    
    private func bind(to viewModel: DishDetailsViewModel) {
        viewModel.dishDetail.observe(on: self) { [weak self] _ in self?.updateView() }
        viewModel.dishDetail.observe(on: self) { [weak self] _ in self?.updateThumbnailImages() }
        viewModel.dishDetail.observe(on: self) { [weak self] _ in self?.updateDetailImages() }
    }
    
    private func updateView() {
        guard let dishDetail = viewModel.dishDetail.value else { return }
        self.title = dishDetail.name
        self.nameLabel.text = dishDetail.name
        self.descriptionLabel.text = dishDetail.description
        let prices = dishDetail.prices
        self.lastPriceLabel.text = "\(prices[0])원"
        pointLabel.text = "\(dishDetail.point)원"
        deliveryInfoLabel.text = dishDetail.deliveryInfo
        deliveryFeeLabel.attributedText = attributedText(withString: "2,500원 (40,000원 이상 구매 시 무료)", boldString: "(40,000원 이상 구매 시 무료)", font: .systemFont(ofSize: 14.0))
    }
    
    private func updateThumbnailImages() {
        guard let thumbImageURLs = viewModel.dishDetail.value?.thumbImages else { return }
        thumbImageURLs.enumerated().forEach { (index, imageURL) in
            NetworkManager().updateThumbImage(imageURL: imageURL) { imageData in
                let image = UIImage(data: imageData)
                let imageView = UIImageView(image: image)
                self.thumbnailImagesScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(thumbImageURLs.count),
                                                                    height: self.view.frame.width)
                imageView.frame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0,
                                         width: self.view.frame.width, height: self.view.frame.width)
                self.thumbnailImagesScrollView.addSubview(imageView)
            }
        }
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    private func updateDetailImages() {
        viewModel.dishDetail.value?.detailImages.forEach { imageURL in
            NetworkManager().updateThumbImage(imageURL: imageURL) { imageData in
                guard let image = UIImage(data: imageData) else { return }
                let ratio = image.size.height / image.size.width
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                self.detailImagesStackView.addArrangedSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: ratio * self.view.frame.width).isActive = true
                
            }
        }
    }
}

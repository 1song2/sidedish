//
//  DetailPageViewController.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import UIKit
import Alamofire

class DetailPageViewController: UIViewController {
    enum KeyColors {
        static let lineSeparatorColor = UIColor(named: "LineSeparatorColor")
        static let eventBadgeBackgroundColor = UIColor(named: "EventBadgeBackgroundColor")
        static let launchBadgeBackgroundColor = UIColor(named: "LaunchBadgeBackgroundColor")
    }
    @IBOutlet weak var thumbnailImagesScrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var badgeStackView: UIStackView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var deliveryInfoLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var detailImagesStackView: UIStackView!
    
    var viewModel: DishDetailsViewModel!
    
    init?(coder: NSCoder, viewModel: DishDetailsViewModel?) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        viewModel.load()
        
        setupViews()
    }
    
    private func setupViews() {
        thumbnailImagesScrollView.isPagingEnabled = true
        orderButton.layer.masksToBounds = true
        orderButton.layer.cornerRadius = 5.0
        quantityLabel.layer.borderWidth = 1.0
        quantityLabel.layer.borderColor = KeyColors.lineSeparatorColor?.cgColor
        setupUI(of: addButton)
        setupUI(of: removeButton)
        
        title = viewModel.title
        nameLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        lastPriceLabel.text = viewModel.lastPrice
        configureOriginalPriceLabel(viewModel.originalPrice)
        configureBadgeStackView(viewModel.badges)
        quantityLabel.text = viewModel.currentQuantity.value.description
        
        removeButton.isEnabled = viewModel.currentQuantity.value > 1
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
    
    private func setupUI(of button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = KeyColors.lineSeparatorColor?.cgColor
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        viewModel.increaseQuantity()
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        viewModel.decreaseQuantity()
    }
    
    private func bind(to viewModel: DishDetailsViewModel) {
        viewModel.additionalInformation.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshView()
            }
        }
        viewModel.thumbImages.observe(on: self) { [weak self] _ in self?.refreshThumbImages() }
        viewModel.detailImages.observe(on: self) { [weak self] _ in self?.refreshDetailImages() }
        viewModel.currentQuantity.observe(on: self) { [weak self] in
            self?.quantityLabel.text = "\($0)"
            self?.viewModel.updateTotalPrice()
            self?.removeButton.isEnabled = viewModel.currentQuantity.value > 1
        }
        viewModel.totalPrice.observe(on: self) { [weak self] price in
            DispatchQueue.main.async {
                self?.totalPriceLabel.text = viewModel.totalPrice.value
            }
        }
    }
    
    private func refreshView() {
        let additionalInformation = viewModel.additionalInformation.value
        pointLabel.text = additionalInformation.point
        deliveryInfoLabel.text = additionalInformation.deliveryMethod
        deliveryFeeLabel.attributedText = NSAttributedString(boldPart: "(40,000원 이상 구매 시 무료)",
                                                             in: additionalInformation.deliveryFee
                                                             ?? "2,500원 (40,000원 이상 구매 시 무료)",
                                                             fontSize: 14.0)
    }
    
    private func refreshThumbImages() {
        let thumbImages = viewModel.thumbImages.value
        thumbImages.enumerated().forEach { index, imageData in
            let image = UIImage(data: imageData)
            let imageView = UIImageView(image: image)
            self.thumbnailImagesScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(thumbImages.count),
                                                                height: self.view.frame.width)
            imageView.frame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0,
                                     width: self.view.frame.width, height: self.view.frame.width)
            self.thumbnailImagesScrollView.addSubview(imageView)
        }
    }
    
    private func refreshDetailImages() {
        detailImagesStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        let detailImages = viewModel.detailImages.value
        detailImages.forEach { imageData in
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

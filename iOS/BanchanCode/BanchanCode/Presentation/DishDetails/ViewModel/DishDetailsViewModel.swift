//
//  DishDetailsViewModel.swift
//  BanchanCode
//
//  Created by Song on 2021/04/28.
//

import Foundation

protocol DishDetailsViewModelInput {
    func load()
    func increaseQuantity()
    func decreaseQuantity()
    func updateTotalPrice()
}

protocol DishDetailsViewModelOutput {
    var detailHash: String { get }
    var title: String { get }
    var description: String { get }
    var originalPrice: String? { get }
    var lastPrice: String { get }
    var badges: [String]? { get }
    var additionalInformation: Observable<AdditionalInformation> { get }
    var thumbImages: Observable<[Data]> { get }
    var detailImages: Observable<[Data]> { get }
    var currentQuantity: Observable<Int> { get }
    var totalPrice: Observable<String> { get }
}

protocol DishDetailsViewModel: DishDetailsViewModelInput, DishDetailsViewModelOutput { }

final class DefaultDishDetailsViewModel: DishDetailsViewModel {
    private var topImagePath: String?
    private var thumbImagePaths: [String] = []
    private var detailImagePaths: [String] = []
    private let dishDetailsRepository: DishDetailsRepository
    private let dishImageRepository: DishImagesRepository
    
    //MARK: - Output
    let detailHash: String
    let title: String
    let description: String
    let originalPrice: String?
    let lastPrice: String
    let badges: [String]?
    var additionalInformation: Observable<AdditionalInformation>
    var thumbImages: Observable<[Data]> = Observable([])
    var detailImages: Observable<[Data]> = Observable([])
    var currentQuantity: Observable<Int> = Observable(1)
    var totalPrice: Observable<String> = Observable("")
    
    //MARK: - Init
    init(dish: Dish,
         dishDetailsRepository: DishDetailsRepository,
         dishImageRepository: DishImagesRepository) {
        self.detailHash = dish.hash
        self.topImagePath = dish.imageURL
        self.title = dish.title
        self.description = dish.description
        self.originalPrice = dish.originalPrice
        self.lastPrice = dish.lastPrice
        self.badges = dish.badges
        self.additionalInformation = Observable(AdditionalInformation())
        self.dishDetailsRepository = dishDetailsRepository
        self.dishImageRepository = dishImageRepository
    }
    
    // MARK: - Private
    private func updateThumbnailImages() {
        thumbImagePaths.forEach { path in
            dishImageRepository.fetchImage(with: path) { result in
                switch result {
                case .success(let data):
                    self.thumbImages.value.append(data)
                case .failure: break
                }
            }
        }
    }
    
    private func updateDetailImages() {
        detailImagePaths.forEach { path in
            dishImageRepository.fetchImage(with: path) { result in
                switch result {
                case .success(let data):
                    self.detailImages.value.append(data)
                case .failure: break
                }
            }
        }
    }
}

//MARK: - Input
extension DefaultDishDetailsViewModel {
    func load() {
        dishDetailsRepository.fetchDishDetails(hash: detailHash) { result in
            switch result {
            case .success(let dishDetail):
                self.additionalInformation.value = dishDetail.additionalInformation
                self.updateTotalPrice()
                guard let thumbImagePaths = dishDetail.additionalInformation.thumbImages else { return }
                guard let detailImagePaths = dishDetail.additionalInformation.detailImages else { return }
                self.thumbImagePaths = thumbImagePaths
                self.detailImagePaths = detailImagePaths
                self.updateThumbnailImages()
                self.updateDetailImages()
            case .failure: break
            }
        }
    }
    
    func increaseQuantity() {
        currentQuantity.value += 1
    }
    
    func decreaseQuantity() {
        currentQuantity.value -= 1
    }
    
    func updateTotalPrice() {
        totalPrice.value = "\((currentQuantity.value * lastPrice.extractedNumbers).commaRepresentation)원"
    }
}

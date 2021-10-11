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
    var topImage: Observable<Data?> { get }
    var title: String { get }
    var description: String { get }
    var originalPrice: String? { get }
    var lastPrice: String { get }
    var badges: [String]? { get }
    
    var additionalInformation: Observable<AdditionalInformation> { get }
    
    var thumbImages: Observable<[Data]> { get }
    var detailImages: Observable<[Data]> { get }
    var currentQuantity: Observable<Int> { get }
    var totalPrice: Observable<Int> { get }
}

protocol DishDetailsViewModel: DishDetailsViewModelInput, DishDetailsViewModelOutput { }

typealias FetchDishDetailsUseCaseFactory = (
    FetchDishDetailsUseCase.RequestValue,
    @escaping (FetchDishDetailsUseCase.ResultValue) -> Void
) -> UseCase

final class DefaultDishDetailsViewModel: DishDetailsViewModel {
    private let fetchDishDetailsUseCaseFactory: FetchDishDetailsUseCaseFactory
    private var topImagePath: String?
    private var thumbImagePaths: [String] = []
    private var detailImagePaths: [String] = []
    private let networkManager: NetworkManager = NetworkManager()
    
    //MARK: - Output
    let detailHash: String
    let topImage: Observable<Data?> = Observable(nil)
    let title: String
    let description: String
    let originalPrice: String?
    let lastPrice: String
    let badges: [String]?
    var thumbImages: Observable<[Data]> = Observable([])
    var detailImages: Observable<[Data]> = Observable([])
    
    var additionalInformation: Observable<AdditionalInformation>
    var currentQuantity: Observable<Int> = Observable(1)
    var totalPrice: Observable<Int> = Observable(0)
    
    init(fetchDishDetailsUseCaseFactory: @escaping FetchDishDetailsUseCaseFactory,
         dish: Dish) {
        self.fetchDishDetailsUseCaseFactory = fetchDishDetailsUseCaseFactory
        self.detailHash = dish.hash
        self.topImagePath = dish.imageURL
        self.title = dish.title
        self.description = dish.description
        self.originalPrice = dish.originalPrice
        self.lastPrice = dish.lastPrice
        self.badges = dish.badges
        
        self.additionalInformation = Observable(AdditionalInformation())
    }
    
    private func getOriginalPrice(from prices: [Int]) -> Int? {
        return prices.count > 1 ? prices.first : nil
    }
    
    private func updateThumbnailImages() {
        thumbImagePaths.forEach { path in
            networkManager.performDataRequest(urlString: path) { imageData in
                self.thumbImages.value.append(imageData)
            }
        }
    }
    
    private func updateDetailImages() {
        detailImagePaths.forEach { path in
            networkManager.performDataRequest(urlString: path) { imageData in
                self.detailImages.value.append(imageData)
            }
        }
    }
}

//MARK: - Input
extension DefaultDishDetailsViewModel {
    func load() {
        let request = FetchDishDetailsUseCase.RequestValue(hash: detailHash)
        let completion: (FetchDishDetailsUseCase.ResultValue) -> Void = { result in
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
        let useCase = fetchDishDetailsUseCaseFactory(request, completion)
        useCase.start()
    }
    
    func increaseQuantity() {
        currentQuantity.value += 1
    }
    
    func decreaseQuantity() {
        currentQuantity.value -= 1
    }
    
    func updateTotalPrice() {
        totalPrice.value = currentQuantity.value * (Int(lastPrice) ?? 0)
    }
}

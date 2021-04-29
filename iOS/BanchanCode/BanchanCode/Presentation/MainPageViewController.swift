//
//  ViewController.swift
//  BanchanCode
//
//  Created by jinseo park on 4/20/21.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var dishCollectionView: UICollectionView!
    private var mainPageDelegate: MainPageCollectionViewDelegate?
    private var mainPageDataSource: MainPageCollectionViewDataSource?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPageDelegate = MainPageCollectionViewDelegate()
        mainPageDataSource = MainPageCollectionViewDataSource()
        
        let categories: [Categorizable] = [MainCategory(), SoupCategory(), SideCategory()]
        
        let viewModels = categories.map { category in
            makeDishesViewModel(category: category)
        }
        
        mainPageDataSource?.viewModels = viewModels
        mainPageDelegate?.viewModels = viewModels
        
        dishCollectionView.delegate = mainPageDelegate
        dishCollectionView.dataSource = mainPageDataSource
        
        viewModels.forEach { viewModel in
            viewModel.load()
            bind(to: viewModel)
        }
        
        registerXib()
    }
    
    func makeFetchDishesUseCase() -> FetchDishesUseCase {
        return DefaultFetchDishesUseCase()
    }
    
    func makeDishesViewModel(category: Categorizable) -> DishesViewModel {
        let category = Observable(category)
        let actions = DishesListViewModelActions(goToDishDetail: goToDishDetail)
        return DefaultDishesViewModel(fetchDishesUseCase: makeFetchDishesUseCase(), category: category, actions: actions)
    }
    
    private func registerXib() {
        let dishNib = UINib(nibName: DishCell.reuseIdentifier, bundle: nil)
        dishCollectionView.register(dishNib, forCellWithReuseIdentifier: DishCell.reuseIdentifier)
        
        let headerNib = UINib(nibName: SectionHeaderView.reuseIdentifier, bundle: nil)
        dishCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dishCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func bind(to viewModel: DishesViewModel) {
        viewModel.category.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
    }
    
    private func updateItems() {
        dishCollectionView.reloadData()
    }
    
    private func goToDishDetail(categoryName: String, dish: Dish) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailPageVC = storyboard.instantiateViewController(identifier: "detailPageVC") as DetailPageViewController
        detailPageVC.categoryName = categoryName
        detailPageVC.id = dish.id
        navigationController?.pushViewController(detailPageVC, animated: true)
    }
}
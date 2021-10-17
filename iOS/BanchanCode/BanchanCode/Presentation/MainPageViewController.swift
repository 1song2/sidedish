//
//  ViewController.swift
//  BanchanCode
//
//  Created by jinseo park on 4/20/21.
//

import UIKit
import RealmSwift
import Alamofire

class MainPageViewController: UIViewController {
    let serialQueue = DispatchQueue(label: "com.song.sectionQueue")
    
    @IBOutlet weak var dishCollectionView: UICollectionView!
    private var viewModel: DishesViewModel!
    private var dishImageRepository: DefaultDishImageRepository?
    lazy var appConfiguration = AppConfiguration()
    lazy var config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
    lazy var concurrentQueue = DispatchQueue(label: "com.song.decodeQueue", attributes: .concurrent)
    lazy var networkService = DefaultNetworkService(config: config,
                                                    session: AF,
                                                    queue: concurrentQueue)
    
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
        registerXib()
        
        viewModel = makeDishesViewModel()
        
        dishCollectionView.delegate = self
        dishCollectionView.dataSource = self
        
        dishImageRepository = DefaultDishImageRepository(networkService: networkService)
        
        bind(to: viewModel)
        viewModel.load { index, items in
            self.serialQueue.sync {
                self.viewModel.update(index: index, items: items)
            }
        }
        
        //App에 저장된 RealmDB파일의 위치를 알 수 있는 함수.
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func makeDishesViewModel() -> DishesViewModel {
        let mainCategoryViewModel = makeCategoryViewModel(sectionIndex: 0, path: "main", phrase: "모두가 좋아하는 든든한 메인요리")
        let soupCategoryViewModel = makeCategoryViewModel(sectionIndex: 1, path: "soup", phrase: "정성이 담긴 뜨끈뜨끈 국물요리")
        let sideCategoryViewModel = makeCategoryViewModel(sectionIndex: 2, path: "side", phrase: "식탁을 풍성하게 하는 정갈한 밑반찬")
        let categories = [mainCategoryViewModel, soupCategoryViewModel, sideCategoryViewModel]
        return DefaultDishesViewModel(categories: categories)
    }
    
    func makeCategoryViewModel(sectionIndex: Int, path: String, phrase: String) -> CategoryViewModel {
        let actions = CategoryViewModelActions(showDishDetails: showDishDetails)
        return DefaultCategoryViewModel(dishesRepository: DefaultDishesRepository(networkService: networkService),
                                        actions: actions,
                                        sectionIndex: sectionIndex,
                                        path: path,
                                        phrase: phrase)
    }
    
    private func registerXib() {
        let dishNib = UINib(nibName: DishCell.reuseIdentifier, bundle: nil)
        dishCollectionView.register(dishNib, forCellWithReuseIdentifier: DishCell.reuseIdentifier)
        
        let headerNib = UINib(nibName: SectionHeaderView.reuseIdentifier, bundle: nil)
        dishCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dishCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func bind(to viewModel: DishesViewModel) {
        viewModel.categories.enumerated().forEach { index, categoryViewModel in
            categoryViewModel.items.observe(on: self) { [weak self] _ in
                self?.updateSection(at: index)
            }
        }
    }
    
    private func updateSection(at index: Int) {
        DispatchQueue.main.sync {
            self.dishCollectionView.reloadSections(IndexSet(integer: index))
        }
    }
    
    private func showDishDetails(dish: Dish) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailPageVC") as DetailPageViewController
        vc.viewModel = vc.makeDishDetailsViewModel(dish: dish)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension MainPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories[section].getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.reuseIdentifier, for: indexPath) as? DishCell else {
            return UICollectionViewCell()
        }
        let dishesItemViewModel = viewModel.categories[indexPath.section].items.value[indexPath.row]
        cell.fill(with: dishesItemViewModel, dishImageRepository: self.dishImageRepository)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        headerView.fill(with: viewModel.categories[indexPath.section])
        headerView.numberOfItems = viewModel.categories[indexPath.section].getNumberOfItems()
        return headerView
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 32.0, height: 130.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 50.0 //32.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.categories[indexPath.section].didSelectItem(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
    }
}

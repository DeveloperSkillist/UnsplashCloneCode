//
//  SearchMainViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class SearchMainViewController: UICollectionViewController {
    private var searchText = ""
    private let searchResultCollectionViewTag = 1
    private var searchPageNum = 0
    private lazy var searchResultCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout22())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = searchResultCollectionViewTag
        
//        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        collectionView.backgroundColor = .red
        collectionView.isHidden = true
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    private var isSearchFetching = false
    var searchItems: [Any] = []
    
    private var discoverPageNum = 0
    private var contents: [SearchMainItem] = [
        SearchMainItem(type: .category, items: []),
        SearchMainItem(type: .discover, items: [])
    ]
    private var isFetching = false
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos, collections, users"
        //ScopeBar 설정
        searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        setupLayout()
        fetchCategories()
        fetchDiscover()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
        
        navigationController?.navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
    }
    
    private func setupCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        
        //Header 추가
        collectionView.register(
            SearchMainCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SearchMainCollectionViewHeader"
        )
        
        //cell 추가
        collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCategoryCollectionViewCell")
        collectionView.register(SearchDiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "SearchDiscoverCollectionViewCell")
        collectionView.collectionViewLayout = layout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(searchResultCollectionView)
        (searchResultCollectionView).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SearchMainViewController {
    
    private func fetchCategories() {
        UnsplashAPI.fetchCategories { [weak self] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      DispatchQueue.main.async {    //에러 발생 시 에러 보여주기
                          self?.showNetworkErrorAlert(error: .networkError)
                      }
                      return
                  }
            
            switch response.statusCode {
            //response 성공 시, 목록 설정하기
            case (200...299):
                do {
                    let fetchedCategories = try JSONDecoder().decode([Category].self, from: data)
                    self?.contents[0].items = fetchedCategories
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                        self?.showNetworkErrorAlert(error: .jsonParsingError)
                    }
                }
                
            default:
                DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                    self?.showNetworkErrorAlert(error: .networkError)
                }
                return
            }
        }
    }
    
    private func fetchDiscover() {
        if isFetching {
            return
        }
        isFetching = true
        
        UnsplashAPI.fetchPhotos(pageNum: discoverPageNum + 1) { [weak self] data, response, error in
            self?.isFetching = false
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      DispatchQueue.main.async {    //에러 발생 시 에러 보여주기
                          self?.showNetworkErrorAlert(error: .networkError)
                      }
                      return
                  }
            
            switch response.statusCode {
            //response 성공 시, 목록 설정하기
            case (200...299):
                do {
                    let fetchedPhotos = try JSONDecoder().decode([Photo].self, from: data)
                    
                    if self?.discoverPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.contents[1].items = fetchedPhotos
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.contents[1].items.append(contentsOf: fetchedPhotos)
                    }
                    
                    DispatchQueue.main.async {
                        //다음 페이지 번호 설정
                        self?.discoverPageNum += 1
                        self?.collectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                        self?.showNetworkErrorAlert(error: .jsonParsingError)
                    }
                }
                
            default:
                DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                    self?.showNetworkErrorAlert(error: .networkError)
                }
                return
            }
        }
    }
    
    func fetchSearch() {
        if isSearchFetching {
            return
        }
        isSearchFetching = true
        
        let searchTypeNum = navigationItem.searchController?.searchBar.selectedScopeButtonIndex ?? 0
        var searchTypeString = navigationItem.searchController?.searchBar.scopeButtonTitles?[searchTypeNum] ?? "photos"
        searchTypeString = searchTypeString.lowercased()
        
        UnsplashAPI.fetchSearchResult(searchText: searchText, searchType: SearchType(rawValue: searchTypeString) ?? SearchType.Photos, pageNum: searchPageNum + 1) { [weak self] data, response, error in
            self?.isSearchFetching = false
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      DispatchQueue.main.async {    //에러 발생 시 에러 보여주기
                          self?.showNetworkErrorAlert(error: .networkError)
                      }
                      return
                  }
            
            switch response.statusCode {
            //response 성공 시, 목록 설정하기
            case (200...299):
                do {
//                    print("data : \(data.description)")
                    let result = try JSONDecoder().decode(SearchPhotos.self, from: data)
                    
                    if self?.searchPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.searchItems = result.results
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.searchItems.append(contentsOf: result.results)
                    }
                    print("itemSize: \(self?.searchItems.count)")
                    
                    DispatchQueue.main.async {
                        //다음 페이지 번호 설정
                        self?.searchPageNum += 1
                        self?.searchResultCollectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                        self?.showNetworkErrorAlert(error: .jsonParsingError)
                    }
                }
                
            default:
                DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                    self?.showNetworkErrorAlert(error: .networkError)
                }
                return
            }
        }
    }
}

extension SearchMainViewController {
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch self?.contents[section].type {
            case .category:
                return self?.createCategorySection()
            case .discover:
                return self?.createDiscoverSection()
            default:
                return nil
            }
        }
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        //아이템
        let itemMargin: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 0, leading: itemMargin, bottom: 0, trailing: itemMargin)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
//        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //TODO discover
    private func createDiscoverSection() -> NSCollectionLayoutSection {
        //아이템
        let itemMargin: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
//        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Header Header size
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        //section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
}

extension SearchMainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case self.collectionView :
            return contents.count
        case searchResultCollectionView:
            return 1
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView :
            return contents[section].items.count
        case searchResultCollectionView:
            print("searchItems : \(searchItems.count)")
            return searchItems.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView :
            switch contents[indexPath.section].type {
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCollectionViewCell", for: indexPath) as? SearchCategoryCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                guard let categories = contents[indexPath.section].items as? [Category] else {
                    return UICollectionViewCell()
                }
                let category = categories[indexPath.row]
                cell.setup(category: category)
                return cell
                
            case .discover:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDiscoverCollectionViewCell", for: indexPath) as? SearchDiscoverCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                guard let photos = contents[indexPath.section].items as? [Photo] else {
                    return UICollectionViewCell()
                }
                let photo = photos[indexPath.row]
                cell.setup(photo: photo)
                return cell
            }
        case searchResultCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let item = searchItems[indexPath.row] as? Photo else {
                return UICollectionViewCell()
            }
            cell.setup(photo: item)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case self.collectionView :
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchMainCollectionViewHeader", for: indexPath) as? SearchMainCollectionViewHeader else {
                    return UICollectionReusableView()
                }
                
                switch contents[indexPath.section].type {
                case .category:
                    headerView.headerLabel.text = "Browse by Category"
                case .discover:
                    headerView.headerLabel.text = "Discover"
                }
                return headerView
            } else {
                return UICollectionReusableView()
            }
        case searchResultCollectionView:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView :
            if indexPath.section != 1 {
                return
            }
            
            let row = indexPath.row
            if row == contents[1].items.count - 11 ||
                row == contents[1].items.count - 6 ||
                row == contents[1].items.count - 1 {
                fetchDiscover()
            }
        case searchResultCollectionView:
            let row = indexPath.row
            if row == searchItems.count - 11 ||
                row == searchItems.count - 6 ||
                row == searchItems.count - 1 {
                fetchSearch()
            }
        default:
            return
        }
    }
}

extension SearchMainViewController: UISearchControllerDelegate {
    
}

extension SearchMainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text ?? ""
        if !searchText.isEmpty {
            searchBar.showsScopeBar = true
            searchResultCollectionView.isHidden = false
            
            view.endEditing(true)
            //search
            searchPageNum = 0
            fetchSearch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
        searchResultCollectionView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //search
        searchPageNum = 0
        fetchSearch()
    }
}

extension SearchMainViewController {
    private func layout22() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
//            switch self?.contents[section].type {
//            case .category:
//                return self?.createCategorySection()
//            case .discover:
//
//            default:
//                return nil
//            }
            return self?.createPhotoSection()
        }
    }
    
    //TODO discover
    private func createPhotoSection() -> NSCollectionLayoutSection {
        //아이템
        let itemMargin: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
//        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

//
//  SearchMainViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class SearchMainViewController: UICollectionViewController {
    private var pageNum = 0
    private var contents: [SearchMainItem] = [SearchMainItem(type: .category, items: []), SearchMainItem(type: .discover, items: [])]
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search photos, collections, users"
        return searchBar
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
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setupCollectionView() {
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
        UnsplashAPI.fetchPhotos(pageNum: pageNum + 1) { [weak self] data, response, error in
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
                    
                    if self?.pageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.contents[1].items = fetchedPhotos
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.contents[1].items.append(contentsOf: fetchedPhotos)
                    }
                    
                    DispatchQueue.main.async {
                        //다음 페이지 번호 설정
                        self?.pageNum += 1
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //TODO discover
    private func createDiscoverSection() -> NSCollectionLayoutSection {
        //아이템
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
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
        return contents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    }
}

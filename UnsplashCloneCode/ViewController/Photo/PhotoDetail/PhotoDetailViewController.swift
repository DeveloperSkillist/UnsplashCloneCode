//
//  PhotoDetailViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    //PhotoListViewController의 목록 위치 변경
    weak var cellChangeDelegate: CellChangeDelegate?
    private lazy var topInfoView: UIView = {
        let topInfoView = UIView()
        topInfoView.backgroundColor = .darkGray
        return topInfoView
    }()
    
    private lazy var titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 25, weight: .bold)
        uiLabel.textColor = .white
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(dismissDetailView), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(sharePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoDetailCollectionViewCell")
        collectionView.layoutIfNeeded()
        return collectionView
    }()
    
    var photos: [Photo] = []
    var startRow = 0
    
    //fullScreen여부에 따라 일부 view hide or show
    private var isFullscreen = false {
        willSet {
            if !newValue {
                topInfoView.isHidden = newValue
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                if newValue {
                    self.topInfoView.alpha = 0.0
                } else {
                    self.topInfoView.alpha = 1.0
                }
            }) { [weak self] success in
                self?.topInfoView.isHidden = newValue
            }
        }
        
        didSet {    //상단바와 하단 홈바 hide or show
            self.setNeedsStatusBarAppearanceUpdate()
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    
    //VC를 pullDown하여 VC 종료 중 일부 view hide or show
    private var isVCDismissing: Bool = false {
        willSet {
            if newValue {
                topInfoView.isHidden = true
                topInfoView.isHidden = true
                view.backgroundColor = .clear
            } else {
                topInfoView.isHidden = isFullscreen
                topInfoView.isHidden = isFullscreen
                view.backgroundColor = .black
            }
        }
    }
    //pullDown에 대한 Y위치를 저장
    private var viewPullDownY: CGFloat = 0
    
    @objc func dismissDetailView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func sharePhoto() {
        var shareObjects: [Any] = []
        shareObjects.append("unsplash_share_title".localized)
        shareObjects.append(photos[currentItemRow].links.html)
        
        let activityViewController = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupGesture()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            collectionView,
            topInfoView
        ].forEach {
            view.addSubview($0)
        }
        
        topInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            cancelButton,
            shareButton,
            titleLabel
        ].forEach {
            topInfoView.addSubview($0)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(20)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(10)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-10)
            $0.bottom.equalTo(topInfoView.snp.bottom).inset(10)
        }
        
        titleLabel.text = photos[startRow].user.name
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        //PhotoListViewController에서 선택한 아이템을 보여주기
        collectionView.scrollToItem(at: IndexPath(row: startRow, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return isFullscreen
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isFullscreen
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCollectionViewCell", for: indexPath) as? PhotoDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(photo: photos[indexPath.row])
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //사진을 변경(스크롤이 끝나면)한 경우 현재 row를 가져와 상단의 사진 정보 변경
        let row = currentItemRow
        titleLabel.text = photos[row].user.name
        cellChangeDelegate?.changedCell(row: row)
    }
    
    var currentItemRow: Int {
        //현재 row 계산하기
        return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: Gesture
extension PhotoDetailViewController {
    func setupGesture() {
        //fullScreen toggle 제스처 등록
        let fullscreenGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        self.view.addGestureRecognizer(fullscreenGesture)
        
        //VC PullDown 제스처 등록
        let pullDownGesture = UIPanGestureRecognizer(target: self, action: #selector(pullDownDismissGesture(sender:)))
        self.view.addGestureRecognizer(pullDownGesture)
    }
    
    //fullScreen toggle 제스처
    @objc func toggleFullScreen() {
        isFullscreen.toggle()
    }
    
    //VC PullDown 제스처
    @objc func pullDownDismissGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
            
        //제스처가 변경중인 경우
        case .changed:
            viewPullDownY = sender.translation(in: view).y
            if viewPullDownY < 0 {  //VC를 위로 올릴 경우, dismiss 수행을 하지 않기 위해서 break
                break
            }

            isVCDismissing = true   //PullDown 진행중인 경우 일부 view hide
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewPullDownY)
                    self.view.alpha = 1 - (self.viewPullDownY / (self.view.bounds.height * 0.7))    //alpha  변경
                }
            )

        //제스처가 끝난 경우
        case .ended:
            //pullDown의 위치를 확인하여, 일정 이동한 경우 dismiss 수행
            if viewPullDownY >= 200 {
                dismiss(animated: true)
                break
            }

            //dismiss를 수행하지 않을 경우, alpha 변경 및 일부 view show
            isVCDismissing = false
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = .identity
                    self.view.alpha = 1
                }
            )

        default:
            break
        }
    }
}

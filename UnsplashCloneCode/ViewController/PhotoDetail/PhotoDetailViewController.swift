//
//  PhotoDetailViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    weak var cellChangeDelegate: CellChangeDelegate?
    private lazy var topInfoView: UIView = {
        let topInfoView = UIView()
        topInfoView.backgroundColor = .darkGray
        return topInfoView
    }()
    
    private lazy var titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 20, weight: .bold)
        uiLabel.textColor = .white
        return uiLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = .systemFont(ofSize: 15)
        uiLabel.textColor = .white
        return uiLabel
    }()
    
    private lazy var topInfoStackView: UIStackView = {
        let stackView = UIStackView()
        [
            titleLabel,
            dateLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
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
    var isFullscreen = false {
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
        
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    var isVCDismissing: Bool = false {
        willSet {
            if newValue {
                topInfoView.isHidden = true
                topInfoView.isHidden = true
                view.backgroundColor = .clear
//                collectionView.backgroundColor = .clear
//                collectionView.backgroundColor = .red
//                self.backgroundView.backgroundColor = .clear
            } else {
                topInfoView.isHidden = isFullscreen
                topInfoView.isHidden = isFullscreen
                view.backgroundColor = .black
//                self.backgroundView.backgroundColor = .black
            }
        }
    }
    var viewPullDownY: CGFloat = 0
    
    @objc func dismissDetailView() {
        self.dismiss(animated: false, completion: nil)
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
            topInfoStackView
        ].forEach {
            topInfoView.addSubview($0)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(topInfoStackView)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(topInfoStackView)
        }
        
        topInfoStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(10)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-10)
            $0.bottom.equalTo(topInfoView.snp.bottom).inset(10)
        }
        
        titleLabel.text = photos[startRow].user.name
        dateLabel.text = "2021.11.25"
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(row: startRow, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
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
        let row = currentItemRow
        titleLabel.text = photos[row].user.name
        cellChangeDelegate?.changedCell(row: row)
    }
    
    var currentItemRow: Int {
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
        let fullscreenGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        self.view.addGestureRecognizer(fullscreenGesture)
        
        let pullDownGesture = UIPanGestureRecognizer(target: self, action: #selector(pullDownDismissGesture(sender:)))
        self.view.addGestureRecognizer(pullDownGesture)
    }
    
    @objc func toggleFullScreen() {
        isFullscreen.toggle()
    }
    
    @objc func pullDownDismissGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewPullDownY = sender.translation(in: view).y
            if viewPullDownY < 0 {
                break
            }

            isVCDismissing = true
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewPullDownY)
                    self.view.alpha = 1 - (self.viewPullDownY / (self.view.bounds.height * 0.7))
                }
            )

        case .ended:
            if viewPullDownY >= 200 {
                dismiss(animated: true, completion: nil)
                break
            }

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

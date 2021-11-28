//
//  UnderTextField.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

//underLine을 가진 TextField
class UnderLineTextField: UITextField {

    //placeHolder 컬러값
    lazy var placeholderColor: UIColor = self.tintColor
    lazy var placeholderString: String = ""
    
    private lazy var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //underline 추가 및 레이아웃 설정
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        //textField 변경 시작과 종료에 대한 action 추가
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //placeholder 설정
    func setPlaceholder(placeholder: String, color: UIColor) {
        placeholderString = placeholder
        placeholderColor = color
        
        setPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
    
    func setPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
    
    func setError() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
        )
        underLineView.backgroundColor = .red
    }
}

extension UnderLineTextField {
    @objc func editingDidBegin() {
        setPlaceholder()
        underLineView.backgroundColor = self.tintColor
    }
    
    @objc func editingDidEnd() {
        underLineView.backgroundColor = placeholderColor
    }
}

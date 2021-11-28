//
//  ResetPasswordViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class ResetPasswordViewController: UIViewController {
    //underLine을 가진 TextField
    private lazy var emailTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.setPlaceholder(
            placeholder: "Email",
            color: .lightGray
        )
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        //button action 추가
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()
    
    @objc func resetPassword() {
        view.endEditing(true)
        
        let title = "reset_title".localized
        var message = "reset_message".localized
        
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.setError()
            message = "input_error_message".localized
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        loginResultAlert.addAction(okAction)
        present(loginResultAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Reset Password"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            emailTextField,
            loginButton
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing = 20
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
    }
}

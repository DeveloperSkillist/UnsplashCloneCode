//
//  LoginViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //underLine을 가진 TextField
    private lazy var emailTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setPlaceholder(
            placeholder: "Email",
            color: .darkGray
        )
        return textField
    }()
    
    //underLine을 가진 TextField
    private lazy var passwordTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setPlaceholder(
            placeholder: "Password",
            color: .darkGray
        )
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Join", for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Login"
        //large title 설정
        navigationController?.navigationBar.prefersLargeTitles = true
        //large title text 설정
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupLayout() {
        view.backgroundColor = .black
        
        [
            emailTextField,
            passwordTextField,
            loginButton,
            forgotPasswordButton,
            joinButton
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing = 20
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
    }
}

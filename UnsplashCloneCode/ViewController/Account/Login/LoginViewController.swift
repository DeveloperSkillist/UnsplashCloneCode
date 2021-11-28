//
//  LoginViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
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
    
    //underLine을 가진 TextField
    private lazy var passwordTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.setPlaceholder(
            placeholder: "Password",
            color: .lightGray
        )
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("login_title".localized, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("find_password_title".localized, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(moveForgotVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("join_title".localized, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(moveJoinVC), for: .touchUpInside)
        return button
    }()
    
    @objc func tryLogin() {
        view.endEditing(true)
        
        let title = "login_result_title".localized
        var message = "login_result_message".localized
        
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.setError()
            message = "input_error_message".localized
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = "input_error_message".localized
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        loginResultAlert.addAction(okAction)
        present(loginResultAlert, animated: true)
    }
    
    @objc func moveForgotVC() {
        let resetPasswordVC = ResetPasswordViewController()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    @objc func moveJoinVC() {
        let joinVC = JoinViewController()
        navigationController?.pushViewController(joinVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Login"
        //large title 설정
        navigationController?.navigationBar.prefersLargeTitles = true
        //large title text 설정
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
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

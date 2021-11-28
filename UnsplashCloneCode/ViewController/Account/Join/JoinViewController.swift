//
//  JoinViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class JoinViewController: UIViewController {
    
    private lazy var firstNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setPlaceholder(
            placeholder: "First name",
            color: .lightGray
        )
        return textField
    }()
    
    private lazy var lastNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setPlaceholder(
            placeholder: "Last name",
            color: .lightGray
        )
        return textField
    }()
    
    private lazy var userNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setPlaceholder(
            placeholder: "User name",
            color: .lightGray
        )
        return textField
    }()
    
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var agreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "By joining, you agree to the Terms and Privacy Policy."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    @objc func trySignUp() {
        let title = "가입 결과"
        var message = "가입에 성공했습니다. 환영합니다."
        
        if firstNameTextField.text?.isEmpty ?? true {
            firstNameTextField.setError()
            message = "누락된 값을 입력하세요."
        }
        
        if lastNameTextField.text?.isEmpty ?? true {
            lastNameTextField.setError()
            message = "누락된 값을 입력하세요."
        }
        
        if userNameTextField.text?.isEmpty ?? true {
            userNameTextField.setError()
            message = "누락된 값을 입력하세요."
        }
        
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.setError()
            message = "누락된 값을 입력하세요."
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = "누락된 값을 입력하세요."
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
        navigationItem.title = "Join Unsplash"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            firstNameTextField,
            lastNameTextField,
            userNameTextField,
            emailTextField,
            passwordTextField,
            signUpButton,
            agreeLabel
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing = 20
        firstNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        lastNameTextField.snp.makeConstraints {
            $0.top.equalTo(firstNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(lastNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        
        agreeLabel.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
}

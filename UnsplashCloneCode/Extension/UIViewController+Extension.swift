//
//  UIViewController+Extension.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/26.
//

import UIKit

extension UIViewController {
    
    //에러 발생 시, 사용자에게 보여줄 alert 구현
    func showNetworkErrorAlert(error: Errors) {
        var errorMessage = "error_etc"
        switch error {
        case .networkError:
            errorMessage = "error_network_message".localized
        case .jsonParsingError:
            errorMessage = "error_json_parsing".localized
        case .dataError:
            errorMessage = "error_data".localized
        case .etc:
            break
        }
        
        let errorTitle = "error".localized
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok".localized, style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}

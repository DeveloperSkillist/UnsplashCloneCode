//
//  UIViewController+Extension.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/26.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: Errors) {
        
        var errorMessage = ""
        
        switch error {
        case .networkError:
            errorMessage = "error_network_message".localized
        case .jsonParsingError:
            errorMessage = "error_json_parsing".localized
        case .dataError:
            errorMessage = "error_data".localized
        case .etc:
            errorMessage = "error_etc".localized
        }
        
        let errorTitle = "error".localized
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok".localized, style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}

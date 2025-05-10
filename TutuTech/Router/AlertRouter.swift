//
//  AlertRouter.swift
//  TutuTech
//
//  Created by Mrmaks on 06.05.2025.
//

import Foundation
import UIKit

protocol AlertRouterProtocol {
    func showAlert()
    func nothingWasFound()
}

final class AlertRouter: AlertRouterProtocol {
    func showAlert() {
        let alert = UIAlertController(title: Constants.noInternet, message: Constants.descriptionMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func nothingWasFound() {
        let noResultAlert = UIAlertController(title: Constants.noResult, message: Constants.nothingWasFound, preferredStyle: .alert)
        noResultAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(noResultAlert, animated: true)
    }
    
    var presentingViewController: CityTableViewController?
    init(presentingViewController: CityTableViewController? = nil) {
        self.presentingViewController = presentingViewController
    }
}

// MARK: - Constants
extension AlertRouter {
    enum Constants {
        static let noInternet: String = "No internet"
        static let ok: String = "OK"
        static let descriptionMessage: String = "Internet connection is required"
        static let noResult: String = "No result"
        static let nothingWasFound: String = "Nothing was found"
    }
}

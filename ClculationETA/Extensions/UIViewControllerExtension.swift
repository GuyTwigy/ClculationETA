//
//  UIViewControllerExtension.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(cancelTouches: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = cancelTouches
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "ok", style: .default) { _ in
                okAction?()
            }
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showConfirmationAlert(title: String, message: String, cancelAction: (() -> Void)? = nil, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelAction?()
        }
        let okButton = UIAlertAction(title: "ok", style: .default) { _ in
            okAction?()
        }
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

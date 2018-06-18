//
//  Extension+UIViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/06/01.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ message: String) {
        let sheet = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        sheet.addAction(action)

        present(sheet, animated: true, completion: nil)
    }
}

//
//  FilerCollectionReusableView.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/06/14.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit

//protocol FilerCollectionReusableViewDelegate: class { //    func sortby() //}

class FilerCollectionReusableView: UICollectionReusableView {
    
//    weak var delegate: FilerCollectionReusableViewDelegate?
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var sortbyItem: UIBarButtonItem!
    
    @IBAction func sortby(_ sender: Any) {
        guard let delegate = UIApplication.shared.delegate else { return }
        guard let ctrl = delegate.window??.rootViewController else { return }
        
        let sheet = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let name = UIAlertAction(title: "Name", style: .default, handler: {(action: UIAlertAction!) in
            self.sortbyItem.title = "Sorted by Name ▼"
            
            //            if self.useCase.store(data: info) {
            //                self.showAlert("successfully download")
            //            } else {
            //                self.showAlert("failed to download video")
            //            }
        })
        let duration = UIAlertAction(title: "Duration", style: .default, handler: {(action: UIAlertAction!) in
            self.sortbyItem.title = "Sorted by Duration ▼"
            //            if self.useCase.store(data: info) {
            //                self.showAlert("successfully download")
            //            } else {
            //                self.showAlert("failed to download video")
            //            }
        })
        let size = UIAlertAction(title: "Size", style: .default, handler: {(action: UIAlertAction!) in
            self.sortbyItem.title = "Sorted by Size ▼"
            //            if self.useCase.store(data: info) {
            //                self.showAlert("successfully download")
            //            } else {
            //                self.showAlert("failed to download video")
            //            }
        })
        let date = UIAlertAction(title: "Date", style: .default, handler: {(action: UIAlertAction!) in
            self.sortbyItem.title = "Sorted by Date ▼"
            //            if self.useCase.store(data: info) {
            //                self.showAlert("successfully download")
            //            } else {
            //                self.showAlert("failed to download video")
            //            }
        })

        sheet.addAction(cancel)
        sheet.addAction(name)
        sheet.addAction(size)
        sheet.addAction(duration)
        sheet.addAction(date)

        ctrl.present(sheet, animated: true, completion: nil)
    }
}

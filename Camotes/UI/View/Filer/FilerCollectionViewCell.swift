//
//  FilerCollectionViewCell.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/20.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit

class FilerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var name: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // cellの枠の太さ
        self.layer.borderWidth = 1.0
        // cellの枠の色
        self.layer.borderColor = UIColor.black.cgColor
        // cellを丸くする
        self.layer.cornerRadius = 8.0
    }
}

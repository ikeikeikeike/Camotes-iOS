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
        
        self.layer.borderWidth  = 1.0
        self.layer.borderColor  = UIColor.black.cgColor
        self.layer.cornerRadius = 8.0
    }
}

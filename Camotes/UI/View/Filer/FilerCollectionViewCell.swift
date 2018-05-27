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
    @IBOutlet weak var image: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        layer.borderWidth  = 1.0
        layer.borderColor  = UIColor.black.cgColor
        layer.cornerRadius = 10.0
    }
}

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
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.backgroundColor =
            Optional(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
    
}

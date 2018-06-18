//
//  Extension+String.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/06/02.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Foundation

extension String {
    func quote() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

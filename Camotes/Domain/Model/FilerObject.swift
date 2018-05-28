//
//  FilerDB.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Foundation
import RealmSwift

public class FilerObject: DBObject {
    @objc dynamic var url          = ""
    @objc dynamic var name         = ""
    @objc dynamic var site         = ""
    @objc dynamic var title        = ""
    @objc dynamic var thumb        = Data()
    var duration                   = RealmOptional<Int>()
//    let likes                      = RealmOptional<Int>()
//    let views                      = RealmOptional<Int>()
}

//
//  FilerDB.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Foundation
import RealmSwift

class FilerDB: Object {
    @objc dynamic var id                = NSUUID().uuidString
    @objc dynamic var url               = ""
    @objc dynamic var site              = ""
    @objc dynamic var title             = ""
    @objc dynamic var thumb: Data?      = nil
    let duration                        = RealmOptional<Int>()
//    let likes                           = RealmOptional<Int>()
//    let views                           = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    //    override static func indexedProperties() -> [String] {
    //        return ["title"]
    //    }
    
}

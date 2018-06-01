//
//  FilerStore.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation
import RealmSwift

protocol FilerStore {
    func find(id: String) -> FilerObject?
    func all() -> Results<FilerObject>
    func save(data: FilerObject) -> Bool
    func delete(data: FilerObject) -> Bool
}

class FilerStoreImpl: DBBase<FilerObject>, FilerStore {}

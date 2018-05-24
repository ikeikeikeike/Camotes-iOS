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
    func get(id: String) -> FilerEntity?
    func all() -> Results<FilerEntity>?
    func save(data: FilerEntity) -> Bool
    func delete(data: FilerEntity) -> Bool
}

class FilerStoreImpl: DBBase<FilerEntity>, FilerStore {}

//
//  DB.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation
import RealmSwift


class DBBase<DBType: Object> {
    let realm = try! Realm()
    
    public func get(id: String) -> DBType? {
        return realm.objects(DBType.self).filter("id == '\(id)'").first
    }
    
    public func all() -> Results<DBType>? {
        return realm.objects(DBType.self)
    }
    
    public func update(data: Object) -> Bool {
        return (try? realm.write { realm.add(data, update: true) }) == nil
    }
    
    public func delete(data: Object) -> Bool {
        return (try? realm.write { realm.delete(data) }) == nil
    }
}

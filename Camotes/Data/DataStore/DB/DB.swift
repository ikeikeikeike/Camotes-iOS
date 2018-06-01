//
//  DB.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation
import RealmSwift

public class DBObject: Object {
    @objc dynamic var id = NSUUID().uuidString
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    //    override static func indexedProperties() -> [String] {
    //        return ["title"]
    //    }
}

class DBBase<DBType: DBObject> {
    let realm = try! Realm()
    
    public func find(id: String) -> DBType? {
        return realm.objects(DBType.self).filter("id == '\(id)'").first
    }
    
    public func all() -> Results<DBType> {
        return realm.objects(DBType.self)  
    }

    public func save(data: DBType) -> Bool {
        return find(id: data.id) == nil ? create(data: data) : update(data: data)
    }
    
    public func create(data: DBType) -> Bool {
        return (try? realm.write { realm.add(data) }) != nil
    }
    
    public func update(data: DBType) -> Bool {
        return (try? realm.write { realm.add(data, update: true) }) != nil
    }
    
    public func delete(data: DBType) -> Bool {
        return (try? realm.write { realm.delete(data) }) != nil
    }
}

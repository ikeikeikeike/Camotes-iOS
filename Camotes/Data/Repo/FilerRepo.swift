//
//  FilerRepo.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation
import RealmSwift

public protocol FilerRepo {
    func get(id: String) -> FilerObject?
    func all() -> Results<FilerObject>
    func save(data: FilerObject) -> Bool
    func delete(data: FilerObject) -> Bool
}

public struct FilerRepoImpl: FilerRepo {
    fileprivate let store: FilerStore! = Injector.ct.resolve(FilerStore.self)
    
    public func get(id: String) -> FilerObject? {
        return store.get(id: id)
    }
    
    public func all() -> Results<FilerObject> {
        return store.all()
    }
    
    public func save(data: FilerObject) -> Bool {
        return store.save(data: data)
    }
    
    public func delete(data: FilerObject) -> Bool {
        return store.delete(data: data)
    }
}

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
    func get(id: String) -> FilerEntity?
    func all() -> Results<FilerEntity>?
    func save(data: FilerEntity) -> Bool
    func delete(data: FilerEntity) -> Bool
}

public struct FilerRepoImpl: FilerRepo {
    fileprivate let store: FilerStore! = Injector.ct.resolve(FilerStore.self)
    
    public func get(id: String) -> FilerEntity? {
        return store.get(id: id)
    }
    
    public func all() -> Results<FilerEntity>? {
        return store.all()
    }
    
    public func save(data: FilerEntity) -> Bool {
        return store.save(data: data)
    }
    
    public func delete(data: FilerEntity) -> Bool {
        return store.delete(data: data)
    }
}

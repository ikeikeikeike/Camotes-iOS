//
//  ScraperRepo.swift
//  ScraperInjector
//
//  Created by Tatsuo Ikeda on 2018/03/16.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Moya
import RxMoya
import RxSwift

public protocol ScraperRepo {
    func info(url: String, handler: @escaping (SingleEvent<SignioEntity>) -> Void)
}

public struct ScraperRepoImpl: ScraperRepo {
    public static let shared: ScraperRepo = ScraperRepoImpl()
    fileprivate let store: ScraperStore! = Injector.ct.resolve(ScraperStore.self)
    
    public func info(url: String, handler: @escaping (SingleEvent<SignioEntity>) -> Void) {
        store.info(url: password, handler: handler)
    }
}

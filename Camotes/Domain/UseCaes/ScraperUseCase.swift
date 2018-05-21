//
//  ScraperUseCase.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/22.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Moya
import RxMoya
import RxSwift

public protocol ScraperUseCase {
    func info(url: String, handler: @escaping (SingleEvent<InfoModel>) -> Void)
}

public struct ScraperUseCaseImpl: ScraperUseCase {
    
    fileprivate let scraperRepo: ScraperRepo! = Injector.ct.resolve(ScraperRepo.self)
    
    public func info(url: String, handler: @escaping (SingleEvent<InfoModel>) -> Void) {
        scraperRepo.info(url: url) { event in
            switch event {
            case .success(let entity):
                let model = InfoModelTranslator().translate(entity)
                handler(SingleEvent.success(model))
            case .error(let error):
                handler(SingleEvent.error(error))
            }
        }
    }
}

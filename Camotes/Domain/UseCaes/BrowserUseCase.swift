//
//  DownloadUseCase.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/22.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Moya
import RxMoya
import RxSwift

public protocol BrowserUseCase {
    func info(url: String, handler: @escaping (SingleEvent<InfoModel>) -> Void)
    func store(data: InfoModel) -> Bool
}

public struct BrowserUseCaseImpl: BrowserUseCase {
    
    fileprivate let scraperRepo: ScraperRepo! = Injector.ct.resolve(ScraperRepo.self)
    fileprivate let filerRepo: FilerRepo! = Injector.ct.resolve(FilerRepo.self)
    
    private let filerObjectTrans = FilerObjectTranslator()
    private let infoModelTrans = InfoModelTranslator()
    
    public func info(url: String, handler: @escaping (SingleEvent<InfoModel>) -> Void) {
        scraperRepo.info(url: url) { event in
            switch event {
            case .success(let entity):
                let model = self.infoModelTrans.translate(entity)
                handler(SingleEvent.success(model))
            case .error(let error):
                handler(SingleEvent.error(error))
            }
        }
    }
    
    public func store(data: InfoModel) -> Bool {
        return filerRepo.save(data: filerObjectTrans.translate(data))
    }
}

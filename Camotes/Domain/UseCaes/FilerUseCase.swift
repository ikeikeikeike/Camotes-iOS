//
//  FilerUseCase.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/25.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import RealmSwift

public protocol FilerUseCase {
    func files() -> Results<FilerObject>
}

public struct FilerUseCaseImpl: FilerUseCase {
    
    fileprivate let filerRepo: FilerRepo! = Injector.ct.resolve(FilerRepo.self)
    
    public func files() -> Results<FilerObject> {
        return filerRepo.all()
    }
}

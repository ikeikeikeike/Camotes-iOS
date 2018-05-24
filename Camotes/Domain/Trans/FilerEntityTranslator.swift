//
//  FilerEntityTranslator.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Foundation
import RealmSwift


internal struct FilerObjectTranslator: Translator {
    internal func translate(_ model: InfoModel) -> FilerObject {
        
        let duration: Int? = Int(model.duration ?? 0)
        let thumb = try! Data(contentsOf: URL(string: model.thumbnail!)!) // TODO:

        let data = FilerObject()
        data.url = model.webpageUrl
        data.site = model.webpageBasename
        data.title = model.title
        data.duration = RealmOptional<Int>(duration)
        data.thumb = thumb
        return data
    }
    
    internal func translate(_ entities: [InfoModel]) -> [FilerObject] {
        return entities.map(translate)
    }
}

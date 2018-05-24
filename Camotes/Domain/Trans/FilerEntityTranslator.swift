//
//  FilerEntityTranslator.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/24.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Foundation
import RealmSwift


internal struct FilerEntityTranslator: Translator {
    internal func translate(_ model: InfoModel) -> FilerEntity {
        
        let duration: Int? = Int(model.duration ?? 0)
        let thumb = try! Data(contentsOf: URL(string: model.thumbnail!)!)

        let data = FilerEntity()
        data.url = model.webpageUrl
        data.site = model.webpageBasename
        data.title = model.title
        data.duration = RealmOptional<Int>(duration)
        data.thumb = thumb
        return data
    }
    
    internal func translate(_ entities: [InfoModel]) -> [FilerEntity] {
        return entities.map(translate)
    }
}

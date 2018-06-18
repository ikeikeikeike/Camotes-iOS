//  Created by Tatsuo Ikeda on 2018/02/19.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation

internal struct InfoModelTranslator: Translator {
    internal func translate(_ entity: InfoEntity) -> InfoModel {
        return InfoModel(
            id: entity.id ?? "",
            title: entity.title ?? "",
            webpageUrl: entity.webpageUrl ?? "",
            webpageBasename: entity.webpageBasename ?? "",
            description: entity.description,
            manifestUrl: entity.manifestUrl,
            ext: entity.ext ?? "",
            url: entity.url,
            protocols: entity.protocols,
            format: entity.format,
            formatId: entity.formatId,
            tbr: entity.tbr,
            extractor: entity.extractor,
            thumbnail: entity.thumbnail,
            duration: entity.duration,
            likeCount: entity.likeCount,
            viewCount: entity.viewCount,
            tags: entity.tags,
            categories: entity.categories,
            entries: entity.entries.map(translate),
            formats: entity.formats.map(translate),
            requestedFormats: entity.requestedFormats.map(translate)
        )
    }

    internal func translate(_ entities: [InfoEntity]) -> [InfoModel] {
        return entities.map(translate)
    }
}

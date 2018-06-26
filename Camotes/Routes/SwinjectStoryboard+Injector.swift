//
//  Created by Tatsuo Ikeda on 2018/02/18.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Swinject

import SwinjectStoryboard
import MZDownloadManager

extension SwinjectStoryboard {
    @objc class func setup() {
        Injector.initialize()

        Routes.initialize()

//        defaultContainer.storyboardInitCompleted(FilerCollectionViewController.self) { _, vc in
//        }

    }

}

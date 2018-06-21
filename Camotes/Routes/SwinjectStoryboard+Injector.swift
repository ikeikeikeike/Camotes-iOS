//
//  Created by Tatsuo Ikeda on 2018/02/18.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import SwinjectStoryboard
import MZDownloadManager

extension SwinjectStoryboard {
    @objc class func setup() {
        Injector.initialize()

        Routes.initialize()

        let ct = SwinjectStoryboard.defaultContainer

        ct.storyboardInitCompleted(FilerCollectionViewController.self) { _, vc in
            let session = "it.ikeikeikeike.Camotes.Filer.BackgroundSession"
            var completion = (UIApplication.shared.delegate as! AppDelegate).backgroundSessionCompletionHandler
            vc.downloadManager = MZDownloadManager(session: session, delegate: vc, completion: completion)
        }

        ct.storyboardInitCompleted(BrowserViewController.self) { _, vc in
            let sb = SwinjectStoryboard.create(name: "Filer", bundle: nil, container: ct)
            let fvc = sb.instantiateViewController(withIdentifier: "FilerCollectionViewController") as! FilerCollectionViewController
            vc.downloadManager = fvc.downloadManager
        }

    }

}

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
            let session: String = "it.ikeikeikeike.Camotes.Filer.BackgroundSession"
            var completion = (UIApplication.shared.delegate as! AppDelegate).backgroundSessionCompletionHandler
            vc.downloadManager = MZDownloadManager(session: session, delegate: vc, completion: completion)

            ct.storyboardInitCompleted(BrowserViewController.self) { _, bvc in bvc.downloadManager = vc.downloadManager }
        }

//        ct.storyboardInitCompleted(FilerCollectionViewController.self) { r, vc in
//            vc.useCase = r.resolve(FilerUseCase.self)
//        }

//        ct.register(LoginPresenter.self) { _ in LoginPresenterImpl() }
//        ct.storyboardInitCompleted(LoginViewController.self) { r, vc in
//            //            vc.tokenKey = r.resolve(TokenKey.self)
//            vc.presenter = r.resolve(LoginPresenter.self)
//        }
    }

}

//
//  Created by Tatsuo Ikeda on 2018/02/18.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        Injector.initialize()
        
        let ct = SwinjectStoryboard.defaultContainer
        
        ct.register(ChartPresenter.self) { _ in ChartPresenterImpl() }
        ct.storyboardInitCompleted(ChartViewController.self) { r, vc in
            vc.presenter = r.resolve(ChartPresenter.self)
        }
        ct.storyboardInitCompleted(CoincheckJPYViewController.self) { r, vc in
            vc.presenter = r.resolve(ChartPresenter.self)
        }
        ct.storyboardInitCompleted(BitflyerJPYViewController.self) { r, vc in
            vc.presenter = r.resolve(ChartPresenter.self)
        }
        ct.storyboardInitCompleted(ZaifJPYViewController.self) { r, vc in
            vc.presenter = r.resolve(ChartPresenter.self)
        }
        
        ct.register(LoginPresenter.self) { _ in LoginPresenterImpl() }
        ct.storyboardInitCompleted(LoginViewController.self) { r, vc in
            //            vc.tokenKey = r.resolve(TokenKey.self)
            vc.presenter = r.resolve(LoginPresenter.self)
        }
    }
    
}

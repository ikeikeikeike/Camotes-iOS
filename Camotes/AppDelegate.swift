//
//  AppDelegate.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/04/15.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {    }
    func applicationDidEnterBackground(_ application: UIApplication) {    }
    func applicationWillEnterForeground(_ application: UIApplication) {    }
    func applicationDidBecomeActive(_ application: UIApplication) {    }
    func applicationWillTerminate(_ application: UIApplication) {    }

    // MARK: - background task

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        NSLog("\(Date()): \(#function), identifier=\(identifier)")
        completionHandler()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("\(Date()): \(#function)")
        completionHandler(.noData)
    }

}

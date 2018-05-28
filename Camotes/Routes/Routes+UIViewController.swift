//
//  Route+UIViewController.swift
//  PracticeDesign
//
//  Created by Tatsuo Ikeda on 2018/03/21.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import UIKit
import Compass

extension UIViewController {
    public func navigate(to route: String){
        (try? Navigator.navigate(urn: route)) ?? print("could not navigate to \(route)")
    }
    
    public func handleRoute(_ url: URL, router: Router)  {
        guard let location = Navigator.parse(url: url) else {
            print("Location not found: \(url.absoluteURL)")
            return
        }
        
        router.navigate(to: location, from: self)
    }
    
    public static var defaultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}

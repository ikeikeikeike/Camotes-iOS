//
//  BrowserViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/04/17.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var browser: WKWebView!
    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browser.navigationDelegate = self
        
        let url = URL(string: "https://google.com")
        let req = URLRequest(url: url!)
        browser.load(req)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = browser.url else {
            return
        }
        
        searchText.text = url.absoluteString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hide keyboard
        if (searchText.isFirstResponder) {
            searchText.resignFirstResponder()
        }
    }
    
    @IBAction func showDownload(_ sender: Any) {
        let sheet = UIAlertController(title: "Download Video", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let action = UIAlertAction(title: "Download", style: .default, handler: {
            (action: UIAlertAction!) in
            print("download!!")
        })

        sheet.addAction(cancel)
        sheet.addAction(action)
        
        present(sheet, animated: true, completion: nil)
    }
    
    
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     // Get the new view controller using segue.destinationViewController.
    //     // Pass the selected object to the new view controller.
    // }

    
    
}


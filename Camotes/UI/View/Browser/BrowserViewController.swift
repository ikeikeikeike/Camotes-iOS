//
//  BrowserViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/04/17.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
    let defaultURL = "https://google.com"

    @IBOutlet weak var browser: WKWebView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        searchText.delegate = self
        browser.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadURL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (searchText.isFirstResponder) {
            searchText.resignFirstResponder() // hide keyboard
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != searchText {
            return true
        }
        if let link = textField.text {
            loadURL(link)
        }
        
        return true
    }

    func showAlert(_ message: String) {
        let sheet = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        sheet.addAction(action)
        
        present(sheet, animated: true, completion: nil)
    }


}

extension String {
    func quote() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

extension BrowserViewController {
    func loadURL() {
        browser.load(URLRequest(url: URL(string: defaultURL)!))
    }
    
    func loadURL(_ link: String) {
        let url = effortURL(link) ?? URL(string: "\(defaultURL)/search?q=\(link.quote())")
        browser.load(URLRequest(url: url!))
    }
    
    // best effort
    func effortURL(_ link: String) -> URL? {
        if URL(string: link)?.scheme != nil {
            return URL(string: link)
        }
        if verifyURL("http://\(link)") {
            return URL(string: "http://\(link)")
        }
        if verifyURL("https://\(link)") {
            return URL(string: "https://\(link)")
        }
        
        return nil
    }

    func verifyURL(_ link: String?) -> Bool {
        guard let link = link, let url = URL(string: link) else {
            return false
        }
        if (url.host?.components(separatedBy: ".").count ?? 0) < 2 {
           return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
}

extension BrowserViewController {
    @IBAction func goBack(_ sender: Any) {
        browser.goBack()
    }
    
    @IBAction func goFoward(_ sender: Any) {
        browser.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        browser.reload()
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
}

extension BrowserViewController {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if (error as! URLError).code == URLError.cancelled {
            return
        }
        
        showAlert("cloud not load page")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        backButton.isEnabled = browser.canGoBack
        forwardButton.isEnabled = browser.canGoForward
    }
    
    // Set current url to search text
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = browser.url {
            searchText.text = url.absoluteString
        }
    }
}

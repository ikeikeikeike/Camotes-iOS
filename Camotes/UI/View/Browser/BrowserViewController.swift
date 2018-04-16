//
//  BrowserViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/04/17.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Do any additional setup after loading the view.
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

    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     // Get the new view controller using segue.destinationViewController.
    //     // Pass the selected object to the new view controller.
    // }

}

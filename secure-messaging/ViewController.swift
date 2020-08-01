//
//  ViewController.swift
//  secure-messaging
//
//  Created by Cody Anderson on 7/31/20.
//  Copyright © 2020 Cody Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func pullFromVault(_ sender: Any) {
    }
    
    @IBOutlet weak var messageField: UITextField!
    
    
    @IBAction func pushToVault(_ sender: Any) {
        
        if let text = messageField.text {
            
            let returnText = encrypt(stringToEncrypt:text)
            print(returnText)
            
        } else {
            print("please enter a valid message")
        }
        
    }
    
    func encrypt (stringToEncrypt:String)->String {
        
        return "Hello Bob"
        
    }
    
    
    @IBOutlet weak var displayMessages: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Hello World")
        
    }


}


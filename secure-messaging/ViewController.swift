//
//  ViewController.swift
//  secure-messaging
//
//  Created by Cody Anderson on 7/31/20.
//  Copyright © 2020 Cody Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

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
        
        let result = convertToHex(stringToEncrypt: stringToEncrypt)
        
        
        
        
        return result
        
    }
    
    func convertToHex (stringToEncrypt:String)-> String {
        
        let testString = stringToEncrypt
        var resultString = ""
        
        for myChar in testString {
            
            let myString = String(myChar.asciiValue!)
            
            let myInt = Int(myString)!
            
            let st = String(format:"%2X", myInt as CVarArg)
            resultString += st
            
        }
        
        return resultString
        
    }
    
    @IBOutlet weak var displayMessages: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}


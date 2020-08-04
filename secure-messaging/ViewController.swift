//
//  ViewController.swift
//  secure-messaging
//
//  Created by Cody Anderson on 7/31/20.
//  Copyright © 2020 Cody Anderson. All rights reserved.
//

import UIKit


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


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
        
        let strategy = "strat1"
        
        var result = convertToHex(stringToEncrypt: stringToEncrypt)
        
        let resultLength = result.count
        
        let numOps = (resultLength)/5
    
        var x = 0
        
        var changeStrings = [String]()
        
        
        while (x < numOps){
            
            let randNum = arc4random_uniform(9)
            
            switch randNum {
                
            case 0:
                if (strategy == "strat1"){
                    let command = swapOne(resultLength: resultLength, inputString: result)
                    changeStrings.append(command[0])
                    result = (command[1])
                } else {
                    print(1)
                }
            case 1:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
                
            case 2:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
                
            case 3:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
            case 4:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
            case 5:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
            case 6:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
            case 7:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
            default:
                if (strategy == "strat1"){
                     print(2)
                } else {
                    print(1)
                }
                
            }
            
            
            x += 1
        }
        
        
        
        return result
        
    }
    
    
    func swapOne (resultLength: Int, inputString:String) -> [String] {
        
        var mutableInputString = inputString
        
        var returnVar = [String]()
        
        let index1 = arc4random_uniform(10)
        let index2 = arc4random_uniform(10)
        let returnString = String(index1) + "?" + String(index2)

        
        let index1Char = inputString[Int(index1)]
        let index2Char = inputString[Int(index2)]
        
        mutableInputString = replace(myString: mutableInputString, Int(index1), Character(index2Char))
        mutableInputString = replace(myString: mutableInputString, Int(index2), Character(index1Char))
        
        returnVar.append(returnString)
        returnVar.append(mutableInputString)
    
        
        return returnVar
    }
    
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
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


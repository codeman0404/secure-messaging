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
            print("after the swaps: " + returnText)
            
        } else {
            print("please enter a valid message")
        }
        
    }
    
    func encrypt (stringToEncrypt:String)->String {
        
        let strategy = "strat1"
        
        var result = convertToHex(stringToEncrypt: stringToEncrypt)
        
        print("before all the swaps :" + result)
        
        var resultLength = result.count
        
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
                    if (resultLength > 9){
                        
                        let command = swapTwo(resultLength: resultLength, inputString: result)
                        changeStrings.append(command[0])
                        result = (command[1])
                    
                    } else {
                        
                        let command = swapOne(resultLength: resultLength, inputString: result)
                        changeStrings.append(command[0])
                        result = (command[1])
                    }
                } else {
                    print(1)
                }
                
            case 2:
                if (strategy == "strat1"){
                     if (resultLength > 99){
                          
                          let command = swapThree(resultLength: resultLength, inputString: result)
                          changeStrings.append(command[0])
                          result = (command[1])
                     
                     } else if (resultLength > 9) {
                        
                         let command = swapTwo(resultLength: resultLength, inputString: result)
                         changeStrings.append(command[0])
                         result = (command[1])
                     } else {
                        
                        let command = swapOne(resultLength: resultLength, inputString: result)
                        changeStrings.append(command[0])
                        result = (command[1])
                    }
                } else {
                    print(1)
                }
                
            case 3:
                if (strategy == "strat1"){
                    
                    let command = addText(resultLength: resultLength, inputString: result)
                    changeStrings.append(command[0])
                    result = (command[1])
                } else {
                    print(1)
                }
            case 4:
                if (strategy == "strat1"){
                     
                     // note that very short strings will not work properly when being encrypted
                     // you can work out this bug later if you have time :)
                     let command = removeText(inputString: result, index: Int(arc4random_uniform(UInt32(resultLength - 2))))
                     changeStrings.append(command[0])
                     result = (command[1])
                } else {
                    print(1)
                }
            default:
                if (strategy == "strat1"){
                     print("case 8")
                } else {
                    print(1)
                }
                
            }
            
            
            x += 1
            resultLength = result.count
        }
        
        print("changeStrings: ")
        print(changeStrings)
        print()
        
        result = insertChangeStrings(changeStrings: changeStrings, inputString: result)
        
        return result
        
    }
    
    func insertChangeStrings (changeStrings: [String], inputString: String) -> String {
        
        var changeStringCounter = 0
        var indexCounter = 0
        var returnString = inputString
        
        while ((indexCounter < returnString.count) && (changeStringCounter < changeStrings.count)){
            
            let randomNum = arc4random_uniform(8)
            
            if ((randomNum == 3) || (randomNum == 7)){
                
                returnString = insertAt(inputString: returnString, stringToAdd: changeStrings[changeStringCounter], index: indexCounter)
                indexCounter = indexCounter + (changeStrings[changeStringCounter]).count
                changeStringCounter = changeStringCounter + 1
            }
            
            indexCounter = indexCounter + 1
        }
        
        if (changeStringCounter < changeStrings.count) {
            
            while (changeStringCounter < changeStrings.count){
                returnString = insertAt(inputString: inputString, stringToAdd: changeStrings[changeStringCounter], index: (returnString.count - 1))
                
                changeStringCounter = changeStringCounter + 1
            }
        }
        
        
        return returnString
    }
    
    
    func swapOne (resultLength: Int, inputString:String) -> [String] {
        
        var mutableInputString = inputString
        
        var index1: Int
        var index2: Int
        var returnString: String
        
        var returnVar = [String]()
        if (resultLength > 9){
            index1 = Int(arc4random_uniform(UInt32(10)))
            index2 = Int(arc4random_uniform(UInt32(10)))
            returnString = String(index1) + "?" + String(index2)
        } else {
            index1 = Int(arc4random_uniform(UInt32(resultLength)))
            index2 = Int(arc4random_uniform(UInt32(resultLength)))
            returnString = String(index1) + "?" + String(index2)
        }

        
        let index1Char = inputString[Int(index1)]
        let index2Char = inputString[Int(index2)]
        
        mutableInputString = replace(myString: mutableInputString, Int(index1), Character(index2Char))
        mutableInputString = replace(myString: mutableInputString, Int(index2), Character(index1Char))
        
        returnVar.append(returnString)
        returnVar.append(mutableInputString)
    
        
        return returnVar
    }
    
    func swapTwo (resultLength: Int, inputString:String) -> [String] {
        
        var mutableInputString = inputString
        
        var index1: Int
        var index2: Int
        var index1String: String
        var index2String: String
        
        var returnVar = [String]()
        if (resultLength > 99){
            index1 = Int(arc4random_uniform(UInt32(99)))
            index2 = Int(arc4random_uniform(UInt32(99)))
            index1String = String(index1)
            index2String = String(index2)
        } else {
            index1 = Int(arc4random_uniform(UInt32(resultLength)))
            index2 = Int(arc4random_uniform(UInt32(resultLength)))
            index1String = String(index1)
            index2String = String(index2)
        }
        
        if (index1 < 10){
            
            index1String = "/" + String(index1)
        }
    
        
        if (index2 < 10){
            
            index2String = "/" + String(index2)
        }
            
        let returnString = index1String + "??" + index2String

        
        let index1Char = inputString[Int(index1)]
        let index2Char = inputString[Int(index2)]
        
        mutableInputString = replace(myString: mutableInputString, Int(index1), Character(index2Char))
        mutableInputString = replace(myString: mutableInputString, Int(index2), Character(index1Char))
        
        returnVar.append(returnString)
        returnVar.append(mutableInputString)
    
        
        return returnVar
    }
    
    func swapThree (resultLength: Int, inputString:String) -> [String] {
        
        var mutableInputString = inputString
        
        var returnVar = [String]()
        
        var index1: Int
        var index2: Int
        var index1String: String
        var index2String: String
        
        if (resultLength > 999){
            index1 = Int(arc4random_uniform(UInt32(1000)))
            index2 = Int(arc4random_uniform(UInt32(1000)))
            index1String = String(index1)
            index2String = String(index2)
        } else {
            index1 = Int(arc4random_uniform(UInt32(resultLength)))
            index2 = Int(arc4random_uniform(UInt32(resultLength)))
            index1String = String(index1)
            index2String = String(index2)
        }
        
        if (index1 < 10){
            
            index1String = "//" + String(index1)
        } else if (index1 < 100){
            
            index1String = "/" + String(index1)
        }
    
        
        if (index2 < 10){
            
            index2String = "//" + String(index2)
            
        } else if (index2 < 100){
            
            index2String = "/" + String(index2)
            
        }
            
        let returnString = index1String + "=" + index2String

        
        let index1Char = inputString[Int(index1)]
        let index2Char = inputString[Int(index2)]
        
        mutableInputString = replace(myString: mutableInputString, Int(index1), Character(index2Char))
        mutableInputString = replace(myString: mutableInputString, Int(index2), Character(index1Char))
        
        returnVar.append(returnString)
        returnVar.append(mutableInputString)
    
        
        return returnVar
    }
    
    func addText(resultLength: Int, inputString:String) -> [String] {
        
        var result = [String]()
        
        let lengthOfString = Int(arc4random_uniform(10))
        
        let elementArray = ["0","1","2","3","4","5","6","7","8","9","A","B","C","C","D","E","F"]
        
        var resultString = ""
        var x = -1
        
        while (x < lengthOfString){
            
            resultString = resultString + elementArray.randomElement()!
            x = x + 1
        }
        
        let indexToInsert = String(Int(arc4random_uniform(UInt32(resultLength))))
        
        let command = "^'" + resultString + "'" + indexToInsert + "^"
        
        result.append(command)
        
        
        let changedString = insertAt(inputString: inputString, stringToAdd: resultString, index: Int(indexToInsert)!)
        
        result.append(changedString)
        
        return result
        
    }
    
    func removeText (inputString: String, index: Int) -> [String] {
        
        var resultString = ""
        var stringRemoved = ""
        var x = 0
        
        let maxVal = (inputString.count) - (index + 1)
        
        var removedLength: Int
        
        if (maxVal > 14){
            removedLength = Int(arc4random_uniform(UInt32(15)))
            
        } else {
            
            removedLength = Int(arc4random_uniform(UInt32(maxVal)))
        }
        
        for char in inputString{
            
            if !((x >= index) && (x <= (index + removedLength))){
                
                resultString = resultString + String(char)
                
            } else {
                
                stringRemoved = stringRemoved + String(char)
            }
            
            x = x + 1
        }
        
        
        var returnVar = [String]()
        
        let command = "^(" + stringRemoved + ")" + String(index) + "^"
        
        returnVar.append(command)
        returnVar.append(resultString)
        
        
        return returnVar
    }
    
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func insertAt (inputString: String, stringToAdd: String, index: Int) -> String {
        
        var result = ""
        var counter = 0
        
        for char in inputString {
            
            if counter != index{
                result = result + String(char)
            } else {
                result = result + String(char)
                result = result + stringToAdd
            }
            
            counter = counter + 1
        }
        
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


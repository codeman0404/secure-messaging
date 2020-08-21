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
            
            // TEST CODE, THIS SHOULD BE REMOVED
            print("now the message will be unencrypted")
            let unencryptedText = unencrypt(stringToUnencrypt: returnText)
            
        } else {
            print("please enter a valid message")
        }
        
    }
    
    func unencrypt(stringToUnencrypt:String) -> String {
        
        var changeStrings = [String]()
        var badIndexList = [Int]()
        
        var x = 0
        
        let length = stringToUnencrypt.count
        
        // extract all of the encryption commands
        while (x < length){
            
            if (stringToUnencrypt[x] == "?"){
                
                if (stringToUnencrypt[x+1] == "?"){
                    
                    
                    
                    let command = createSubstring(startIndex:(x-2), endIndex:(x+3), inputString:stringToUnencrypt)
                    
                    let type = "??"
                    changeStrings.append(type)
                    changeStrings.append(command)
                    
                    badIndexList.append(x-2)
                    badIndexList.append(x-1)
                    badIndexList.append(x)
                    badIndexList.append(x+1)
                    badIndexList.append(x+2)
                    badIndexList.append(x+3)


                    
                    x = x + 3
                    
                } else {
                    
                    let type = "?"
                    let command = createSubstring(startIndex:(x-1), endIndex:(x+1), inputString:stringToUnencrypt)
                    
                    changeStrings.append(type)
                    changeStrings.append(command)
                    
                    badIndexList.append(x-1)
                    badIndexList.append(x)
                    badIndexList.append(x+1)
                    
                    x = x + 1
                    
                }
                
            } else if (stringToUnencrypt[x] == "="){
                
                let command = createSubstring(startIndex:(x-3), endIndex:(x+3), inputString:stringToUnencrypt)
                let type = "="
                
                changeStrings.append(type)
                changeStrings.append(command)
                
                badIndexList.append(x-3)
                badIndexList.append(x-2)
                badIndexList.append(x-1)
                badIndexList.append(x)
                badIndexList.append(x+1)
                badIndexList.append(x+2)
                badIndexList.append(x+3)
                
                x = x + 3
                
            } else if (stringToUnencrypt[x] == "^"){
                
                if (stringToUnencrypt[x+1] == "("){
                    
                    badIndexList.append(x)
                    var tempX = (x + 1)
                    
                    while (stringToUnencrypt[tempX] != "^"){
                        
                        badIndexList.append(tempX)
                        
                        tempX = tempX + 1
                        
                    }
                    
                    badIndexList.append(tempX)
                    
                    let command = createSubstring(startIndex: x, endIndex: tempX, inputString: stringToUnencrypt)
                    let type = "()"
                    
                    changeStrings.append(type)
                    changeStrings.append(command)
                    
                    x = tempX
                    
                } else {
                    
                    badIndexList.append(x)
                    var tempX = (x + 1)
                    
                    while (stringToUnencrypt[tempX] != "^"){
                        
                        badIndexList.append(tempX)
                        
                        tempX = tempX + 1
                        
                    }
                    
                    badIndexList.append(tempX)
                    
                    let command = createSubstring(startIndex: x, endIndex: tempX, inputString: stringToUnencrypt)
                    let type = "''"
                    
                    changeStrings.append(type)
                    changeStrings.append(command)
                    
                    x = tempX
                    
                }
                
            }
            
            x = x + 1
        }
        
        // build a new string without the commands
        var i = 0
        var cleanedString = ""
        for char in stringToUnencrypt {
            
            if (notIn(currentIndex: i, listOfBadIndices: badIndexList)){
                
                cleanedString = cleanedString + String(char)
                
            }
            
            i = i + 1
            
            
        }
        
        print()
        print("commands: ")
        print(changeStrings)
        print("this is the cleaned string without being flipped back :)")
        print(cleanedString)
        
        
        // Perform all the operations to unscramble the strings
        var commandCounter = 0
        var typeCounter = 1
        changeStrings = changeStrings.reversed()
        
        while typeCounter < changeStrings.count {
            
            if (changeStrings[typeCounter] == "''") {
                
                let command = changeStrings[commandCounter]
                
                var indexCounter = 2
                var text = ""
                var index = ""
                
                while (command[indexCounter] != "'"){
                    
                    text = text + command[indexCounter]
                    indexCounter = indexCounter + 1
                }
                
                indexCounter = indexCounter + 1
                
                while (command[indexCounter] != "^"){
                    
                    index = index + command[indexCounter]
                    indexCounter = indexCounter + 1
                }
                
                let intIndex = Int(index)!
                let length = text.count
                
                cleanedString = removeAt(inputString: cleanedString, index: intIndex, length: length)
                
                
                
                
                
            } else if (changeStrings[typeCounter] == "()"){
                
                let command = changeStrings[commandCounter]
                
                var indexCounter = 2
                var text = ""
                var index = ""
                
                while (command[indexCounter] != ")"){
                    
                    text = text + command[indexCounter]
                    indexCounter = indexCounter + 1
                }
                
                indexCounter = indexCounter + 1
                
                while (command[indexCounter] != "^"){
                    
                    index = index + command[indexCounter]
                    indexCounter = indexCounter + 1
                }
            
                let intIndex = Int(index)!
                
                // subtract intIndex by 1 to compensate for how insertAt works
                cleanedString = insertAt(inputString: cleanedString, stringToAdd: text, index: (intIndex - 1))
                
            } else if (changeStrings[typeCounter] == "?"){
                
                let command = changeStrings[commandCounter]
                
                let index1 = Int(command[0])!
                let index2 = Int(command[2])!
               
                let index1Char = cleanedString[index1]
                let index2Char = cleanedString[index2]
                
                cleanedString = replace(myString: cleanedString, Int(index1), Character(index2Char))
                cleanedString = replace(myString: cleanedString, Int(index2), Character(index1Char))
                
                
            } else if (changeStrings[typeCounter] == "??"){
                
                let command = changeStrings[commandCounter]
                
                var index1 = command[0] + command[1]
                var index2 = command[4] + command[5]
                
                if (index1[0] == "/"){
                    
                    index1 = index1[1]
                    
                }
                
                if (index2[0] == "/"){
                    
                    index2 = index2[1]
                    
                }
                
                let intIndex1 = Int(index1)!
                let intIndex2 = Int(index2)!
                
                let char1 = cleanedString[intIndex1]
                let char2 = cleanedString[intIndex2]
                
                cleanedString = replace(myString: cleanedString, intIndex1, Character(char1))
                cleanedString = replace(myString: cleanedString, intIndex2, Character(char2))
                
            } else if (changeStrings[typeCounter] == "="){
                
                let command = changeStrings[commandCounter]
                
                var index1 = command[0] + command[1] + command[2]
                var index2 = command[4] + command[5] + command[6]
                
                if (index1[0] == "/"){
                    
                    if (index1[1] == "/"){
                        
                        index1 = index1[2]
                        
                        
                    } else {
                        
                        index1 = index1[1] + index1[2]
                        
                    }
                    
                }
                
                if (index2[0] == "/"){
                    
                    if (index2[1] == "/"){
                        
                        index2 = index2[2]
                        
                        
                    } else {
                        
                        index2 = index2[1] + index2[2]
                        
                    }
                    
                }
                
                let intIndex1 = Int(index1)!
                let intIndex2 = Int(index2)!
                
                let char1 = cleanedString[intIndex1]
                let char2 = cleanedString[intIndex2]
                
                cleanedString = replace(myString: cleanedString, intIndex1, Character(char1))
                cleanedString = replace(myString: cleanedString, intIndex2, Character(char2))
                
            }
            
            typeCounter = typeCounter + 2
            commandCounter = commandCounter + 2
        }
        
        
        print()
        print("this should now be the hex string in the correct order")
        print("text: " + cleanedString)
        
        
        return cleanedString
    }
    
    func notIn(currentIndex: Int, listOfBadIndices: [Int]) -> Bool {
        
        for index in listOfBadIndices {
            
            if (index == currentIndex) {
                return false
            }
            
        }
        
        
        return true
    }
    
    func createSubstring(startIndex:Int, endIndex:Int, inputString: String) -> String {
        
        var substring = ""
        var counter = startIndex
        while (counter <= endIndex){
            
            substring = substring + inputString[counter]
            counter = counter + 1
        }
        
        return substring
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
    
    func removeAt (inputString: String, index: Int, length: Int) -> String {
        
        var returnString = ""
        var x = 0
        for char in inputString {
            
            // this may need to be shifted forward by 1
            if !((x > index) && (x <= (index + length))){
                
                returnString = returnString + String(char)
                
            }
            
            x = x + 1
            
        }
        
        return returnString
        
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


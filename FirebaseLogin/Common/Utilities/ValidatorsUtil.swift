//
//  ValidatorsUtil.swift
//  FirebaseLogin
//
//  Created by alaattinbulut on 17.06.2021.
//

import Foundation

class ValidatorsUtil {
    
    class func usernameValidator(inputText: String) -> Bool {
        return inputText.count >= 3
    }
    
    class func emailValidator(inputText: String) -> Bool {
        let inputTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return inputTest.evaluate(with: inputText)
    }

    class func fullnameValidator(inputText: String) -> Bool {
        return inputText.count >= 5 && inputText.contains(" ")
    }
    
    class func passwordValidator(inputText: String) -> Bool {
        let inputTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#._])[A-Za-z\\d$@$!%*?&#._]{8,}")
        return inputTest.evaluate(with: inputText)
    }
}

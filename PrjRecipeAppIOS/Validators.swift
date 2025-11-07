//
//  Validators.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import Foundation

enum Validators {
    static func checkEmail (_ email: String) -> Bool{
        let pattern = #"^\S+@\S+\.\S+$"# //can use in all of our projects
        return email.range(of: pattern, options: .regularExpression) != nil
        
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}


//simple error , custom error
struct SimpleError: Error {
    let message : String
    
    init(_ message: String){ //_ so that the external parapeter is null
        self.message = message
    }
    
    var localizedDescription: String { //we can jus use .localized description and we can get the message
        return message
    }
}

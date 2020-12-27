//
//  DefaultsUtils.swift
//  ChatApp
//
//  Created by Joan Cabezas on 25/12/20.
//

import Foundation

class DefaultsUtils {
    let defaults = UserDefaults.init()
    
    func setUserData(user: User) {
        let data = try? JSONEncoder().encode(user)
        defaults.set(data, forKey: "user_data")
    }
    
    func getUserData() -> User {
        let userData = defaults.data(forKey: "user_data")!
        let user = try! JSONDecoder().decode(User.self, from: userData)
        print("Retrieving user \(user)")
        return user
    }
    
    func clearUserData(){
        defaults.removeObject(forKey: "user_data")
    }
}

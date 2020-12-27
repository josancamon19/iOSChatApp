//
//  User.swift
//  ChatApp
//
//  Created by Joan Cabezas on 24/12/20.
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

struct User: Codable {
    let id, firebaseUid, name, email: String

    enum CodingKeys: String, CodingKey {
        case id
        case firebaseUid = "firebase_uid"
        case name, email
    }
    
    static func fromDocument(data: [String: Any]) -> User{
        return User(id: "\(data["id"]!)", firebaseUid: "\(data["firebase_uid"]!)", name: "\(data["name"] ?? "")", email: "\(data["email"]!)")
    }
}

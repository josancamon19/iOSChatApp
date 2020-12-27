//
//  Message.swift
//  ChatApp
//
//  Created by Joan Cabezas on 25/12/20.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let message = try? newJSONDecoder().decode(Message.self, from: jsonData)

import Foundation

// MARK: - Message
struct Message: Codable {
    let id, date, sender, receiver: String
    let text: String
    
    static func fromDocument(data: [String: Any]) -> Message{
        return Message(id: "\(data["id"]!)", date: "\(data["date"]!)", sender: "\(data["sender"]!)", receiver: "\(data["receiver"]!)", text: "\(data["text"]!)")
    }
}

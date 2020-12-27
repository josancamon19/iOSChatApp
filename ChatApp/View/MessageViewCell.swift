//
//  MessageViewCell.swift
//  ChatApp
//
//  Created by Joan Cabezas on 25/12/20.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var messageText : UILabel!
    @IBOutlet weak var messageSender : UILabel!
    
    func setMessage(message: Message, myUser: User, userToChat: User){
        messageText.text = message.text

        if message.sender == myUser.id {
            messageSender.text = myUser.email
            messageText.textAlignment = .right
            messageSender.textAlignment = .right
        } else{
            messageSender.text = userToChat.email
            messageText.textAlignment = .left
            messageSender.textAlignment = .left
        }
    }
    
}

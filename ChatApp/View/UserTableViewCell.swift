//
//  UserTableViewCell.swift
//  ChatApp
//
//  Created by Joan Cabezas on 25/12/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    func setUserData(user: User ){
        userName.text = user.name
        userEmail.text = user.email
    }

}

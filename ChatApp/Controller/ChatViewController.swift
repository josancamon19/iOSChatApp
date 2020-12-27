//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Joan Cabezas on 24/12/20.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private let defaults = DefaultsUtils()
    private var chatCollection : CollectionReference!

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    private var messages = [Message]()
    private var myUser : User!
    private var userToChat: User!
    private var chatDocument: String!
    
    func setUsersToChat(myUser: User, userToChat: User){
        self.userToChat = userToChat
        self.myUser = myUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));

        
        // Think is the fatest/best performance overall way for saving and retrieving messages
        chatDocument = [self.myUser.id, self.userToChat.id].sorted().joined(separator: "-")
        chatCollection = db.collection("messages").document(chatDocument).collection("chat")
        
        initMessagesListener()
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let text = chatTextField.text ?? ""
        if text != "" {
            self.sendMessage(text: text)
            chatTextField.text = ""
        }
    }
}

// MARK: Messages TableView setup
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageViewCell {
            cell.setMessage(message: messages[indexPath.row], myUser: self.myUser, userToChat: self.userToChat)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));
            return cell
        }
        return MessageViewCell()
    }
}

// MARK: Firebase chat utilities
extension ChatViewController {
    
    func initMessagesListener(){
        chatCollection.order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            for document in snapshot!.documents {
                print(document.data())
            }
            self.messages = snapshot!.documents.map { (document) -> Message in
                Message.fromDocument(data: document.data())
            }
            self.messagesTableView.reloadData()
        }
    }
    
    func sendMessage(text: String){
        let doc = chatCollection.document()
        doc.setData([
            "id" : doc.documentID,
            "date": Date(),
            "sender" : self.myUser.id,
            "receiver" : self.userToChat.id,
            "text" : text
        ])
    }
}

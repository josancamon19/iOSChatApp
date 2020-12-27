//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Joan Cabezas on 24/12/20.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    private let db = Firestore.firestore()
    private var myUser : User!
    private var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.delegate = self
        usersTableView.dataSource = self
        self.myUser = DefaultsUtils().getUserData()
        loadUsers()
    }
    
    func loadUsers(){
        db.collection("users").getDocuments { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                
                self.users = snapshot!.documents.filter({ (snapshot) -> Bool in
                    print(self.myUser!.id)
                    return self.myUser.id != snapshot.documentID
                }).map { (document) -> User in
                    User.fromDocument(data: document.data())
                }
                self.usersTableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Sign out successful")
            DefaultsUtils().clearUserData()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


// MARK: TableView setup
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userViewCell") as? UserTableViewCell {
            cell.setUserData(user: users[indexPath.row])
            return cell
        }
        return UserTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatSegue", sender: users[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatViewController {
            let userToChat = sender as! User
            destination.setUsersToChat(myUser: myUser, userToChat: userToChat)
        }
    }
}

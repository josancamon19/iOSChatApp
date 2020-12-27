//
//  ViewController.swift
//  ChatApp
//
//  Created by Joan Cabezas on 24/12/20.
//

import UIKit
import GoogleSignIn
import Firebase


class LoginViewController: UIViewController {
    
    private var firebaseAuth = Auth.auth()
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        if firebaseAuth.currentUser != nil {
            self.performSegue(withIdentifier: "signedInSegue", sender: nil)
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

// MARK: Google Sign In
extension LoginViewController : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        firebaseAuth.signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let result = authResult {
                    self.setUserData(user: result.user) { (documentId) in
                        DefaultsUtils().setUserData(user: User(id: documentId, firebaseUid: result.user.uid, name: result.user.displayName ?? "", email: result.user.email!))
                        self.performSegue(withIdentifier: "signedInSegue", sender: nil)
                    }
                }
            }
        }
        
    }
}

// Mark: Firebase
extension LoginViewController {
    
    func setUserData(user: Firebase.User, onCompleted : @escaping (_ documentId: String) -> Void) -> Void {
        let usersCollection = db.collection("users")
        usersCollection.whereField("email", isEqualTo: user.email!).getDocuments { (snapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                if snapshot?.documents.count ?? 0 > 0 {
                    if let userId = snapshot?.documents[0].data()["id"] {
                        onCompleted(userId as! String)
                    }
                } else {
                    let document = usersCollection.document()
                    document.setData([
                        "id" : document.documentID,
                        "name": user.displayName!,
                        "email": user.email!,
                        "firebase_uid": user.uid,
                    ])
                    onCompleted(document.documentID)
                }
            }
        }
    }
}



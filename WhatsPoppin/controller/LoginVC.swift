//
//  LoginVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 29/05/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase

class LoginVC: UIViewController {
    
    let fbLoginManager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }

    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }

    @IBAction func facebookLogin(sender: UIButton) {
        AccessToken.current = nil
            fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { LoginResult in
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
//             Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = ["provider": user.providerID, "username": user.uid, "facebookUsername": "tap to enter"] as [String: Any]
                        DataService.instance.updateCurrentUser(uid: (AccessToken.current?.userId)!, userData: userData)
                    } else if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        fbLoginManager.logOut()
        AccessToken.current = nil
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch (let error) {
                print(error)
            }
        }
        print("logged out")
        print(AccessToken.current?.authenticationToken as Any)
    }
}

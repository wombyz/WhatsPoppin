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
import FirebaseAuth

class LoginVC: UIViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /**
     Called when the button was used to logout.
     
     - parameter loginButton: Button that was used to logout.
     */
    public func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    /**
     Called when the button was used to login and the process finished.
     
     - parameter loginButton: Button that was used to login.
     - parameter result:      The result of the login.
     */
    public func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print("Error \(error)")
            break
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            loginFireBase()
            print("success")
            break
        default: break
            
        }
        
    }
    
    
    
    /**
     Login to Firebase after FB Login is successful
     */
    
    
    func loginFireBase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error == nil {
                if let user = user {
                        let userData = ["provider": user.providerID] as [String: Any]
                        print(user.uid)
                        print(Auth.auth().currentUser?.uid)
                        DataService.instance.updateCurrentPassenger(uid: user.uid, userData: userData)
                    }
                }
                print("email user auth algood with firebase")
            }
    }
}


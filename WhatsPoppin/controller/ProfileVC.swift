//
//  ProfileVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 6/10/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookShare
import FacebookLogin

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var hostedNumber: UILabel!
    @IBOutlet weak var attendedNumber: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var currrentUserFBID: String?
    var facebookUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        currrentUserFBID = AccessToken.current?.userId
        print(currrentUserFBID)
        
        DataService.instance.REF_USERS.child(currrentUserFBID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["facebookUsername"]
            self.facebookUsername = username as? String
            self.usernameButton.setTitle(self.facebookUsername, for: .normal)
        })
        
        loadProfilePic(uid: currrentUserFBID!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    func loadProfilePic(uid: String) {
        DataService.instance.REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let picLink = value?["pictureURL"] as? String
            if let imageURL = picLink {
                print(imageURL)
                let url = URL(string: imageURL)
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.profilePic.image = image
            }
        }
    }
    
    
    @IBAction func usernameButtonPressed(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Edit Facebook Username?", message: "If your username is not that of your own Facebook account, users will not be able to contact you via messenger. If it is incorrect, ensure you change it before hosting any events.", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let editActionButton = UIAlertAction(title: "Edit", style: .default)
        { _ in
            let alert = UIAlertController(title: "Change Facebook Username", message: "Enter your username:", preferredStyle: .alert)
            
            alert.addAction(cancelActionButton)
            
            alert.addTextField { (textField) in
                textField.text = "e.g. richardsmith07"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let username = textField?.text
                print("Text field: \(username)")
                
                self.updateCurrentUserFBUsername(username: username, uid: AccessToken.current?.userId)
                self.viewDidLoad()
                self.viewWillAppear(true)
            }))
            
            self.present(alert, animated: true, completion: nil)

        }
        actionSheetController.addAction(editActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    
    
    func updateCurrentUserFBUsername(username: String?, uid: String?) {
        DataService.instance.REF_USERS.child(uid!).updateChildValues(["facebookUsername": username])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")!

        return cell
    }
}








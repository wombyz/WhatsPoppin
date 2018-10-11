//
//  ViewEventVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 3/08/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FacebookShare

class ViewEventVC: UIViewController {

    var annotationKey: String!
    var creator: String?
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var descriptionField: UILabel!
    @IBOutlet weak var ageRangeLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var suburbLbl: UILabel!
    @IBOutlet weak var eventTypeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Passed to ViewVC \(annotationKey)")
        // Do any additional setup after loading the view.
        
        pullAndLoadEventData(eventKey: annotationKey)
    }
    
    @IBAction func unwindToViewEventVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func dismissViewEventVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func pullAndLoadEventData(eventKey: String) {
        DataService.instance.REF_EVENTS.child(eventKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var title = value?["title"] as? String
            var gender = value?["gender"] as? String
            var suburb = value?["suburb"] as? String
            var age = value?["ageRange"] as? String
            var date = value?["date"] as? String
            var type = value?["eventType"] as? String
            var description = value?["description"] as? String
            self.creator = value?["creator"] as? String
        
            self.titleLbl.text = title
            self.genderLbl.text = gender
            self.suburbLbl.text = suburb
            self.ageRangeLbl.text = age
            self.dateLbl.text = date 
            self.eventTypeLbl.text = type
            self.descriptionField.text = description
        })
    }

    @IBAction func requestButton(_ sender: UIButton) {

        DataService.instance.REF_USERS.child(creator!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let creatorUsername = value?["facebookUsername"] as? String
            if let usrnme: String = creatorUsername {
                print(usrnme)
                
                let urlString = ("fb-messenger://user-thread/\(String(describing: usrnme))")
                
                print(urlString)
                
                let url = URL(string: urlString)
                print(url)
                
                    // Attempt to open in Messenger App first
                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                        if success == false {
                            // Messenger is not installed. Open in browser instead.
                            let url = URL(string: "https://m.me/\(usrnme)")
                            if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!)
                            }
                        }

                    })
            } else {
                print("error in url")
            }
        })
    }
}

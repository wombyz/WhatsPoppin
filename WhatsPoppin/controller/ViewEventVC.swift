//
//  ViewEventVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 3/08/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import Firebase

class ViewEventVC: UIViewController {

    var annotationKey: String!
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
            var creator = value?["creator"] as? String
        
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
        if let id = sender.titleLabel?.text {
            if let url = URL(string: "fb-messenger://user-thread/\(id)") {
                
                // Attempt to open in Messenger App first
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                    
                    if success == false {
                        // Messenger is not installed. Open in browser instead.
                        let url = URL(string: "https://m.me/\(id)")
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!)
                        }
                    }
                })
            }
        }
    }
}

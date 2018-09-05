//
//  HostReviewVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 10/08/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import Firebase

class HostReviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    var hostReviews = [Review]()
    var attendeeReviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    func pullHostReviews(user: String) {
//        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let userData = value?["\(user)"] as? NSDictionary
//            let reviewDict = userData!["reviews"] as? NSDictionary
//            let hostRevs = reviewDict!["host"] as? NSArray
//            for review in hostRevs! {
//                self.hostReviews.append(review as! Review)
//            }
//        })
//    }
//    
//    func pullAttendeeReviews(user: String) {
//        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let userData = value?["\(user)"] as? NSDictionary
//            let reviewDict = userData!["reviews"] as? NSDictionary
//            let attendedRevs = reviewDict!["attended"] as? Dictionary<String, AnyObject>
//            for review in attendedRevs! {
//                review = NSArray
//                self.attendeeReviews.append(review as! Review)
//            }
//        })
//    }
//    
//    func loadReviewData()
    
    @IBAction func refreshTapped(_ sender: Any) {
    }
    
    @IBAction func dismissReviewScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = hostReviews.count
            break
        case 1:
            returnValue = attendeeReviews.count
            break
        default:
            break
        }
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        return myCell
    }
    
    @IBAction func segChanged(_ sender: Any) {
        myTableView.reloadData()
    }
    
}

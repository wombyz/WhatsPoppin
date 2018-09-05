//
//  ViewEventVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 3/08/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit

class ViewEventVC: UIViewController {

    var annotationKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(annotationKey)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToViewEventVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func dismissViewEventVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

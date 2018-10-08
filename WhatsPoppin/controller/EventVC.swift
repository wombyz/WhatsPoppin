//
//  EventVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 7/10/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit

class EventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var previousEventsButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")!
        return cell
    }
}

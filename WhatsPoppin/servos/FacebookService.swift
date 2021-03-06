//
//  FacebookService.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 7/10/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import FacebookCore

class FacebookService {
    static let instance = FacebookService()

    let params = ["fields": "email, first_name, last_name, link, picture.type(large), name, id"]

    func recordUserData() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in

            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    let link = ("facebook.com/")
                    let email = responseDictionary["email"] as! String
                    let fbId = responseDictionary["id"] as! String
                    let name = responseDictionary["name"] as! String
                    let fname = responseDictionary["first_name"] as! String
                    let lname = responseDictionary["last_name"] as! String
                    let id = responseDictionary["id"] as! String
                    
                    let picture = responseDictionary["picture"] as? NSDictionary
                    let data = picture!["data"] as? NSDictionary
                    let url = data!["url"] as! String
                
                    UpdateService.instance.updateUserData(email: email, fname: fname, lname: lname, link: link, pictureURL: url, name: name, FBid: id)
                    
                    print("Link: \(link)")
                    print(url)

                }
            }
        }
    }
}

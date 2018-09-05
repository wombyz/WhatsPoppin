//
//  Review.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 16/08/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import Foundation

class Review {
    var starRating: Double?
    var title: String?
    var review: String?
    var author: String?
    
    init(starRating: Double, title: String, review: String, author: String) {
        self.starRating = starRating
        self.title = title
        self.review = review
        self.author = author
    }
    
}

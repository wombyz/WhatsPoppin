//
//  TransparentNavigationBar.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 6/06/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
//         Make the navigation bar transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        
    }
}


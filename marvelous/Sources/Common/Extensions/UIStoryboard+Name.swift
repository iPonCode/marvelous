//  UIStoryboard+Name.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    // This extension is to avoid hardcoded storyboard names, new names must be added here
    enum Name: String {
        case main   = "Main"

        var filename: String { return rawValue.firstCapitalized }
    }
    
    convenience init(_ name: Name, bundle: Bundle? = nil) {
        self.init(name: name.filename, bundle: bundle)
    }
    
}

//  Storyboarded.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName: String) -> Self?
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(storyboardName: String) -> Self? {
        
        let fullName = NSStringFromClass(self) //"MyApp.MyViewController"
        // splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".").last!

        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        // instantiate a view controller with that identifier
        // and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
    
    static func instantiate(from storyboardName: UIStoryboard.Name) -> Self? {
        instantiate(storyboardName: storyboardName.filename)
    }
}

extension UIViewController: Storyboarded {}

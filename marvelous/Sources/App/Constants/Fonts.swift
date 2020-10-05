//  Fonts.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit

extension UIFont {
    
    struct AppFont {
        
        static var largeTitle: UIFont {
            get {
                let fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
                if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: .black)
                    .fontDescriptor.withDesign(.rounded) {
                    return UIFont(descriptor: descriptor, size: fontSize)

                } else {
                    return UIFont.preferredFont(forTextStyle: .largeTitle)
                }
            }
        }
        
        static var bodyText: UIFont {
            get {
                let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
                if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: .regular)
                    .fontDescriptor.withDesign(.rounded) {
                    return UIFont(descriptor: descriptor, size: fontSize)

                } else {
                    return UIFont.preferredFont(forTextStyle: .body)
                }
            }
        }
        
        static var compactTitle: UIFont {
            get {
                let fontSize = UIFont.preferredFont(forTextStyle: .title1).pointSize
                if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
                    .fontDescriptor.withDesign(.rounded) {
                    return UIFont(descriptor: descriptor, size: fontSize)

                } else {
                    return UIFont.preferredFont(forTextStyle: .title1)
                }
            }
        }

        static var barButton: UIFont {
            get {
                let fontSize = UIFont.preferredFont(forTextStyle: .title3).pointSize
                if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: .bold)
                    .fontDescriptor.withDesign(.rounded) {
                    return UIFont(descriptor: descriptor, size: fontSize)

                } else {
                    return UIFont.preferredFont(forTextStyle: .headline)
                }
            }
        }
        
    }
}

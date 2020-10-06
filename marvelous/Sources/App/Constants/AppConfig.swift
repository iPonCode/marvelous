//  AppConfig.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit

// MARK: - App Configuration

struct AppConfig {
    
    // Bar buttons
    static let barBack = "chevron.left"
    static let barBackTrans = "chevron.left.2"
    static let barRightList = "rectangle.compress.vertical"
    static let barShowOptions = "table.badge.more.fill"
    static let barSaveOptions = "rectangle.fill.badge.checkmark"
    static let barCloseOptions = "table.badge.more.fill"
    
    // Cell icons
    static let cellFav = "star.fill"
    static let cellWatched = "eye.fill"
    static let cellLink = "link.circle"
    static let emptyListIcon = "info.circle"
    
    // Screen size
    static let screenSize: CGRect = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    static let halftScreenHeight = screenSize.height / 2

    private init() {}
    
}

//  ErrorResponse.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import Foundation

// To manage server errors
struct ErrorResponse: Codable {
    var code, message: String
    
    init(){
        self.code = ""
        self.message = ""
    }
}

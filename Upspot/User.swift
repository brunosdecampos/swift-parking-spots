//
//  User.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-24.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var phoneNumber: String
    var image: String
    
    init(data: JSON) {
        self.name = data["name"].stringValue
        self.phoneNumber = data["phone-number"].stringValue
        self.image = data["user-image"].stringValue
    }
    
}

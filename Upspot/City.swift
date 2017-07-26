//
//  City.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-17.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation

class City {
    
    var name: String
    var image: String
    var latitude: Float
    var longitude: Float
    
    init(data: JSON) {
        self.name = data["name"].stringValue
        self.image = data["image"].stringValue
        self.latitude = data["latitude"].floatValue
        self.longitude = data["longitude"].floatValue
    }
    
}

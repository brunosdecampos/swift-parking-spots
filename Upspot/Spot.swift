//
//  Spot.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-24.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation

class Spot {
    
    var type: String
    var address: String
    var image: String
    var fromTime: String
    var toTime: String
    var stringTime: String
    var stringWeekdays: String
    var price: Int
    var weekdays: Array<Bool>
    
    init(data: JSON) {
        self.type = data["type"].stringValue
        self.address = data["address"].stringValue
        self.image = data["image"].stringValue
        self.fromTime = data["from"].stringValue
        self.toTime = data["to"].stringValue
        self.price = data["price"].intValue
        
        self.weekdays = []
        self.stringTime = ""
        self.stringWeekdays = ""
        
        for item in data["weekdays"].arrayValue {
            self.weekdays.append(item["day"].boolValue)
        }
    }
    
    init(type: String, address: String, image: String, time: String, price: Int, weekdays: String) {
        self.type = type
        self.address = address
        self.image = image
        self.price = price
        self.stringTime = time
        self.stringWeekdays = weekdays
        
        self.fromTime = ""
        self.toTime = ""
        self.weekdays = []
    }
    
}

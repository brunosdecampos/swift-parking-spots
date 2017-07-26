//
//  BookingViewController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-17.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import UIKit
import CoreData

class BookingViewController: UIViewController {
    
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet var weekDays: [UIButton]! // Collection of 7 buttons (from Monday to Sunday)
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bookingButton: CustomButton!
    
    var selectedSpot: Int?
    var totalPrice: Int = 0
    var totalSelectedDays: Int = 0
    var spotType: String?
    var allowBooking: Bool?
    //var objects = Array<JSON>()
    var weekDaysClickCounter = Array<Int>()
    var availableDays = Array<Bool>()
    var selectedWeekdays = Array<String>()
    var spots: Array<Spot>!
    var users: Array<User>!
    
    let labelDays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing navigation back button
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.hidesBackButton = true
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        if selectedSpot != nil {
            if let file = Bundle(for: AppDelegate.self).path(forResource: "spot-details", ofType: "json") {
                let data = NSData(contentsOfFile: file)! as Data
                let json = JSON(data: data)
                self.parseJSON(json: json)
                //self.objects = json["spots"].arrayValue
            }
            
            setAllImages()
            setAllComponents()
            prepareButton()
        }
        
        setTextWithLineSpacing(label: address, text: address.text!, lineSpacing: 7)
    }
    
    func parseJSON(json: JSON) {
        spots = Array<Spot>()
        users = Array<User>()
        
        for (key, item) in json["spots"] {
//            if Int(key) == selectedSpot! {
                spots.append(Spot(data: item))
                users.append(User(data: item))
//                spots.insert(Spot(data: item), at: selectedSpot!)
//                users.insert(User(data: item), at: selectedSpot!)
//            }
        }
        
//        for item in json["spots"].arrayValue {
//            spots.append(Spot(data: item))
//        }
    }
    
    func setAllImages() {
        self.loadImage(component: "spot", imageURL: spots[selectedSpot!].image) // spots[selectedSpot!]["image"].stringValue
        self.loadImage(component: "user", imageURL: users[selectedSpot!].image) // spots[selectedSpot!]["user-image"].stringValue
        
        var marker: String
        
        if spots[selectedSpot!].type == "available" { // objects[selectedSpot!]["type"].stringValue
            marker = "green-parking-icon"
            self.allowBooking = true
        }
        else if spots[selectedSpot!].type == "special" {
            marker = "blue-parking-icon"
            self.allowBooking = true
        }
        else {
            marker = "gray-parking-icon"
            self.allowBooking = false
        }
        
        self.spotType = spots[selectedSpot!].type // objects[selectedSpot!]["type"].stringValue
        self.loadImage(component: "marker", imageURL: marker)
    }
    
    func loadImage(component: String, imageURL: String) {
        if component == "marker" {
            DispatchQueue.main.async {
                self.markerImage.image = UIImage(named: imageURL)
            }
        }
        else {
            if let url = URL(string: imageURL) {
                let session = URLSession.shared
                
                let task = session.dataTask(with: url) { (data, response, error) -> Void in
                    if data != nil {
                        DispatchQueue.main.async {
                            if component == "spot" {
                                self.spotImage.image = UIImage(data: data!)
                            }
                            else if component == "user" {
                                self.userImage.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
    }
    
    func setAllComponents() {
        name.text = users[selectedSpot!].name // objects[selectedSpot!]["name"].stringValue
        phoneNumber.text = users[selectedSpot!].phoneNumber // objects[selectedSpot!]["phone-number"].stringValue
        
        var availability: String
        
        if self.spotType == "available" {
            availability = "Available spot at"
        }
        else if self.spotType == "special" {
            availability = "Available special spot at"
        }
        else {
            availability = "Unavailable spot at"
        }
        
        address.text = "\(availability) \(spots[selectedSpot!].address)" // objects[selectedSpot!]["address"].stringValue
        
//        var buttonColour: UIColor
//        var textButtonColour: UIColor
        //var count: Int = 0
        
        //for day in objects[selectedSpot!]["weekdays"].arrayValue {
        for (index, day) in spots[selectedSpot!].weekdays.enumerated() {
            //print(index)
            
//            print("Button:")
//            print(weekDays[count])
            //if day["day"].stringValue == "true" {
            
            if day == true {
                setButtonColourAsAvailable(button: weekDays[index]) // setButtonColourAsAvailable(button: weekDays[count])
            }
            else {
                setButtonColourAsUnavailable(button: weekDays[index]) // setButtonColourAsUnavailable(button: weekDays[count])
            }
            
//            weekDays[count].backgroundColor = buttonColour
//            weekDays[count].setTitleColor(textButtonColour, for: UIControlState.normal)
            
            //availableDays.append(NSString(string: day["day"].stringValue).boolValue)
            availableDays.append(day)
            weekDaysClickCounter.append(0)
            
            //count += 1
        }
        
        time.text = "From \(spots[selectedSpot!].fromTime) to \(spots[selectedSpot!].toTime)"//time.text = "From \(objects[selectedSpot!]["from"].stringValue) to \(objects[selectedSpot!]["to"].stringValue)"
        price.text = "$\(spots[selectedSpot!].price)"
    }
    
    func prepareButton() {
        if self.allowBooking == false {
            // Setting a disabled colour: #666666
            self.bookingButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        }
    }
    
    // Setting text spacing for any label
    func setTextWithLineSpacing(label: UILabel, text: String, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        label.attributedText = attrString
    }
    
    func setButtonColourAsAvailable(button: UIButton) {
        button.backgroundColor = UIColor(red: 221/255, green: 234/255, blue: 241/255, alpha: 1.0) // Light Blue
        button.setTitleColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0), for: UIControlState.normal) // Gray
    }
    
    func setButtonColourAsUnavailable(button: UIButton) {
        button.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0) // Very Light Gray
        button.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0), for: UIControlState.normal) // Light Gray
    }
    
    func setButtonColourAsSelected(button: UIButton) {
        if availableDays[button.tag] == true {
            if weekDaysClickCounter[button.tag] % 2 == 0 {
                button.backgroundColor = UIColor(red: 0/255, green: 187/255, blue: 216/255, alpha: 1.0) // Blue
                button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: UIControlState.normal) // White
                
                self.totalSelectedDays += 1
                calculateFinalPrice()
            }
            else {
                button.backgroundColor = UIColor(red: 221/255, green: 234/255, blue: 241/255, alpha: 1.0) // Light Blue
                button.setTitleColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0), for: UIControlState.normal) // Gray
                
                self.totalSelectedDays -= 1
                calculateFinalPrice()
            }
            
            weekDaysClickCounter[button.tag] += 1
        }
    }
    
    @IBAction func didSelectWeekDay(_ sender: UIButton) {
        setButtonColourAsSelected(button: sender)
        selectedWeekdays.append(labelDays[sender.tag])
    }
    
    @IBAction func didBookASpot(_ sender: UIButton) {
        if self.allowBooking == true {
            if validateBooking() {
                let time = spots[selectedSpot!].fromTime + " - " + spots[selectedSpot!].toTime
                var weekdaysString: String = ""
                
                for (index, day) in selectedWeekdays.enumerated() {
                    weekdaysString += day
                    
                    if index < (selectedWeekdays.count - 1) {
                        weekdaysString += ", "
                    }
                }
                
                let spotsElements: Dictionary<String, Any> = [
                    "type": spots[selectedSpot!].type,
                    "address": spots[selectedSpot!].address,
                    "weekdays": weekdaysString,
                    "image": spots[selectedSpot!].image,
                    "price": totalPrice,
                    "time": time
                ]
                
                let usersElements: Dictionary<String, Any> = [
                    "name": users[selectedSpot!].name,
                    "phoneNumber": users[selectedSpot!].phoneNumber,
                    "image": users[selectedSpot!].image
                ]
                
                saveCoreData(entityName: "Spots", elements: spotsElements)
                saveCoreData(entityName: "Users", elements: usersElements)
                
                performSegue(withIdentifier: "HistorySegue", sender: nil)
            }
        }
    }
    
    // Calculate final price for the spot with selected week days
    func calculateFinalPrice() {
        if totalSelectedDays > 0 {
            totalPrice = spots[selectedSpot!].price * self.totalSelectedDays // totalPrice = Int(self.objects[selectedSpot!]["price"].stringValue)! * self.totalSelectedDays
        }
        
        price.text = "$\(totalPrice)"
    }
    
    func validateBooking() -> Bool {
        // No one days were selected
        if self.totalSelectedDays == 0 {
            Alert.displayBasicAlert(title: "Ops", message: "Select at least one weekday", in: self)
            
            return false
        }
        
        // At least one day was selected
        return true
    }
    
    func saveCoreData(entityName: String, elements: Dictionary<String, Any>) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let entity = NSManagedObject(entity: entityDescription, insertInto: managedContext)
        
        for (key, item) in elements {
            entity.setValue(item, forKey: key)
        }
        
        //entity.setValue(spots[selectedSpot!].address, forKey: "address")
//        spotEntity.setValue(weekdays, forKey: "weekdays")
//        spotEntity.setValue(spots[selectedSpot!].image, forKey: "image")
//        spotEntity.setValue(totalPrice, forKey: "price")
//        spotEntity.setValue(time, forKey: "time")
        
        do {
            try managedContext.save()
        }
        catch {
            Alert.displayBasicAlert(title: "Error in saving data", message: error as! String, in: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

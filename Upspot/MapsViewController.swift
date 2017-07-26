//
//  ViewController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-14.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController, GMSMapViewDelegate {
    
    var citySelected: Int?
    var cities: Array<City>!
    var city: Int!
    var markerSelected: Int?
    var latitudes: Array<Float>!
    var longitudes: Array<Float>!
    var JSONFile: String?
    var spots: Array<JSON>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing navigation back button
        self.navigationItem.hidesBackButton = true
        
        if UserDefaults.standard.string(forKey: "City") == nil {
            self.city = 0
        }
        else if Int(UserDefaults.standard.string(forKey: "City")!)! >= 0 {
            self.city = Int(UserDefaults.standard.string(forKey: "City")!)!
        }
        
        self.latitudes = []
        self.longitudes = []
        
        cities = Array<City>()
        
        if let file1 = Bundle(for: AppDelegate.self).path(forResource: "cities", ofType: "json") {
            let data1 = NSData(contentsOfFile: file1)! as Data
            let json1 = JSON(data: data1)
            
            for item1 in json1["countries"].arrayValue {
                for item2 in item1["cities"].arrayValue {
                    self.cities.append(City(data: item2))
                }
            }
        }
        
        for city in cities {
            self.latitudes.append(city.latitude)
            self.longitudes.append(city.longitude)
        }
        
        if self.citySelected != nil {
            city = self.citySelected!
        }
        
        if let file2 = Bundle(for: AppDelegate.self).path(forResource: "markers", ofType: "json") {
            let data2 = NSData(contentsOfFile: file2)! as Data
            let json2 = JSON(data: data2)
            
            spots = json2["spots"].arrayValue
        }
        
        // Create a GMSCameraPosition that tells the map to display the coordinate
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(self.latitudes[city]), longitude: CLLocationDegrees(self.longitudes[city]), zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        
        var parkingIcon: String
        
        if spots.count > 0 {
            for item in spots {
                if item["type"].stringValue == "available" {
                    parkingIcon = "green-parking-icon"
                }
                else if item["type"].stringValue == "special" {
                    parkingIcon = "blue-parking-icon"
                }
                else {
                    parkingIcon = "gray-parking-icon"
                }
                
                // Creates a marker in the center of the map
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(item["latitude"].stringValue)!), longitude: CLLocationDegrees(Float(item["longitude"].stringValue)!))
                marker.icon = UIImage(named: parkingIcon)
                marker.userData = Int(item["id"].stringValue) // index
                marker.map = mapView
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.markerSelected = marker.userData as? Int
        performSegue(withIdentifier: "BookingSegue", sender: nil)
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookingSegue" {
            let receiverViewController = segue.destination as! BookingViewController
            
            if self.markerSelected != nil {
                receiverViewController.selectedSpot = self.markerSelected!
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


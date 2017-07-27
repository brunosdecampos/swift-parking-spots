//
//  CitiesViewController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-17.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var citySelected: Int?
    var latitude: Float?
    var longitude: Float?
    var JSONFile: String?
    var cities: Array<City>!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing navigation back button
        self.navigationItem.hidesBackButton = true
        
        cities = Array<City>()
        
        if let file = Bundle(for: AppDelegate.self).path(forResource: "cities", ofType: "json") {
            let data = NSData(contentsOfFile: file)! as Data
            let json = JSON(data: data)
            
            for item1 in json["countries"].arrayValue {
                for item2 in item1["cities"].arrayValue {
                    cities.append(City(data: item2))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.citySelected = indexPath.row
        defaults.set(indexPath.row, forKey: "City")
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverViewController = segue.destination as! MapsViewController
        
        if self.citySelected != nil {
            receiverViewController.citySelected = self.citySelected!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cities != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CitiesTableViewCellController
            cell.feedCityCell(city: self.cities[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

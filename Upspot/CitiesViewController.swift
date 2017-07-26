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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing navigation back button
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        
        Alert.deleteCoreData(entity: "Spots")
        Alert.deleteCoreData(entity: "Users")
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
//        let currCell = tableView.cellForRow(at: indexPath) as! CitiesTableViewCellController
//        self.leagueSelected = currCell.teamName!.text
        self.citySelected = indexPath.row
//        self.latitude = currCell.latitude
//        self.longitude = currCell.longitude

        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverViewController = segue.destination as! MapsViewController
//        receiverViewController.weekSelected = self.weekSelected
//        receiverViewController.leagueSelected = self.leagueSelected
//        print(self.latitude)
//        print(self.longitude)
        
        if self.citySelected != nil {
            receiverViewController.citySelected = self.citySelected!
        }
//        if self.latitude != nil {
//            receiverViewController.latitude = self.latitude!
//        }
//        if self.longitude != nil {
//            receiverViewController.longitude = self.longitude!
//        }
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

//
//  CitiesTableViewCellController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-17.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation
import UIKit

class CitiesTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func feedCityCell(city: City) {
        self.cityName.text = city.name
        self.loadCityImage(imageURL: city.image)
    }
    
    func loadCityImage(imageURL: String) {
        if let url = URL(string: imageURL) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { (data, response, error) -> Void in
                if data != nil {
                    DispatchQueue.main.async {
                        self.cityImage.image = UIImage(data: data!)
                    }
                }
            }
            
            task.resume()
        }
    }
}

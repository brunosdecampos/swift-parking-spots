//
//  HistoryTableViewCellController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-21.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func feedHistoryCell(spot: Spot) {
        self.address.text = spot.address
        self.days.text = spot.stringWeekdays
        self.time.text = spot.stringTime
        self.price.text = "$\(spot.price)"
        self.loadSpotImage(imageURL: spot.image)
        
        setTextWithLineSpacing(label: self.address, text: address.text!, lineSpacing: 7)
    }
    
    func loadSpotImage(imageURL: String) {
        if let url = URL(string: imageURL) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { (data, response, error) -> Void in
                if data != nil {
                    DispatchQueue.main.async {
                        self.spotImage.image = UIImage(data: data!)
                    }
                }
            }
            
            task.resume()
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
    
}

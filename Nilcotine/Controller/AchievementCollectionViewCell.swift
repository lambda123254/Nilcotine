//
//  AchievementCollectionViewCell.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 23/06/22.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    var achievement: [Achievement] = []
    
    @IBOutlet var AchievementImage: UIImageView!
    @IBOutlet var AchievementLabel: UILabel!
    
    static let identifier = "AchievementCollectionViewCell"
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        
        for i in 0 ..< achievement.count {
            let achievementBadge = achievement[i].achievementImage
            let achievementLabel = achievement[i].achievementName
            
            AchievementImage.image = UIImage(named: "\(achievementBadge)")
            AchievementLabel.text = achievementLabel

        }
      
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "AchievementCollectionViewCell", bundle: nil)
    }

}

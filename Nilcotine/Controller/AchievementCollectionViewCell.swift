//
//  AchievementCollectionViewCell.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 23/06/22.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    var ClaimButtonTapped: (() -> ())?

    var achievement: [Achievement] = []
    
    @IBOutlet var AchievementImage: UIImageView!
    @IBOutlet var AchievementLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var claimButton: UIButton!
    static let identifier = "AchievementCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        claimButton.isHidden = true
        // Initialization code
        
    }
    
    @IBAction func claimButtonPressed(_ sender: Any) {
        ClaimButtonTapped?()
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

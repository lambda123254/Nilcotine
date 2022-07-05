//
//  ProfileCollectionViewCell.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 20/06/22.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    var ClaimButtonTapped: (() -> ())?

    @IBOutlet var AchievementImage: UIImageView!
    @IBOutlet var AchievementLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var claimButton: UIButton!
    static let identifier = "ProfileCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        claimButton.isHidden = true
        // Initialization code
    }

    @IBAction func claimButtonPressed(_ sender: Any) {
        ClaimButtonTapped?()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
    }

}

//
//  ProfileCollectionViewCell.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 20/06/22.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var achievementImageView: UIImageView!
    
    static let identifier = "ProfileCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage) {
        achievementImageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
    }

}

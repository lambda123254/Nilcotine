//
//  OnboardingCollectionViewCell.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 24/06/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self )
    
    @IBOutlet weak var OnboardingDescLabel: UILabel!
    @IBOutlet weak var OnboardingTitleLabel: UILabel!
    @IBOutlet weak var OnboardingImageView: UIImageView!
    
    
    
    func setup(_ slide: OnboardingSlide) {
        OnboardingImageView.image = slide.image
        OnboardingTitleLabel.text = slide.title
        OnboardingDescLabel.text = slide.description
    }
    
    
}

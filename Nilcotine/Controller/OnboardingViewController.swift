//
//  OnboardingViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 09/06/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var OnboardingCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")
    
    var slides: [OnboardingSlide] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            OnboardingSlide(title: "Welcome to Nilcotine", description: "Together, we will start your journey in reducing nicotine addiction. Are you ready?", image: <#T##UIImage#>),
            OnboardingSlide(title: "See your progress", description: <#T##String#>, image: <#T##UIImage#>),
            OnboardingSlide(title: "Explore other users", description: <#T##String#>, image: <#T##UIImage#>),
            OnboardingSlide(title: "Share your journey", description: <#T##String#>, image: <#T##UIImage#>)
        ]
        OnboardingCollectionView.delegate = self
        OnboardingCollectionView.dataSource = self
        
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    
    
    
//    @IBAction func startedButtonPressed(_ sender: Any) {
//        Task {
//            try? await ck.createProfile()
//        }
//
//    }


}

extension OnboardingViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
}

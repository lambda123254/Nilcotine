//
//  ProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 20/06/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var collectionViewProfile: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 108, height: 152)
//        
//        collectionViewProfile.collectionViewLayout = layout
        
        collectionViewProfile.register(ProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        collectionViewProfile.delegate = self
        collectionViewProfile.dataSource = self

        // Do any additional setup after loading the view.
    }
    

}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("Collection View tapped")
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        cell.configure(with: UIImage(named: "Achievement_Locked")!)
        
        return cell
    }
    
    
}
//
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 108, height: 152)
//    }
//}

//
//  AllAchievementViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 23/06/22.
//

import UIKit
import CloudKit

class AllAchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var achievement = AchievementData()
    var achievementBadgeShow: String?
    var achievementLabelShow: String?
    
    var userIdForDb: CKRecord.ID?
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Achievements")
    var iconNameUse : [String] = []

    
    @IBOutlet weak var AchievementCollection: UICollectionView!
    
    //let achievement = AchievementData()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Task {
            
            let data = try await ck.get(option: "all", format: "")
            let userId = try await ck.getUserID()
            userIdForDb = userId
            
            for i in 0 ..< data.count {
                
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    let iconName = data[i].value(forKey: "iconName") as! String
                    
                    iconNameUse.append(iconName)
                    
                } // if
            }// for
        }
        
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 160)
        AchievementCollection.collectionViewLayout = layout
        
        AchievementCollection.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        
        AchievementCollection.delegate = self
        AchievementCollection.dataSource = self

        
    }
    
    
    // Collection View Function
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("Tapped")
    }
    
    
    // return berapa kali rownya muncul
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return achievement.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.identifier, for: indexPath) as! AchievementCollectionViewCell
        
        // TODO logic achievement unlock sama lock
        // Tampung data tampungan buat gambar2 badge biar bisa bandingin
        
        
        
        
        achievementBadgeShow = achievement.data[indexPath.row].achievementImage
        achievementLabelShow = achievement.data[indexPath.row].achievementName
            

            
        cell.AchievementImage.image = UIImage(named: "\(achievementBadgeShow!)")
        cell.AchievementLabel.text = "\(achievementLabelShow!)"
            
//
//        if iconNameUse[] == achievementBadgeShow {
//            print("test")
//        }
        
        // cari2
            
            
        
        return cell
    }

}

// Customize Collection View
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 160)
    }
}

/*
 Table Achievement
 if userID di achievement = nil
 gambar lock
 
 else
 show badge
 
 
 
 */

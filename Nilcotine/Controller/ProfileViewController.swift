//
//  ProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 20/06/22.
//

import UIKit
import CloudKit

class ProfileViewController: UIViewController {
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet var collectionViewProfile: UICollectionView!
    
    @IBOutlet weak var textViewMotivation: UITextView!
    @IBOutlet weak var textViewStory: UITextView!
    
    @IBOutlet weak var tableRelapse: UITableView!
    
    struct Relapse {
        let relapseTime: String
        let relapseDate: String
    }
    
    let dummyData: [Relapse] = [
        Relapse(relapseTime: "14 days 7 hours 52 minutes", relapseDate: "07/06/2022"),
        Relapse(relapseTime: "8 days 10 hours 30 minutes", relapseDate: "18/05/2022"),
        Relapse(relapseTime: "5 days 8 hours 7 minutes", relapseDate: "25/03/2022"),
        Relapse(relapseTime: "5 days 8 hours 7 minutes", relapseDate: "25/03/2022"),
        Relapse(relapseTime: "5 days 8 hours 7 minutes", relapseDate: "25/03/2022"),
        Relapse(relapseTime: "5 days 8 hours 7 minutes", relapseDate: "25/03/2022"),
    ]
    
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableRelapse.dataSource = self
        tableRelapse.delegate = self
        
        Task {
            let data = try await ck.get(option: "all", format: "")

            let userId = try await ck.getUserID()

            for i in 0 ..< data.count {
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {

//                    var achievement = data[i].value(forKey: "achievement") as! String
                    var age = data[i].value(forKey: "age") as! Int
//                    var motivation = data[i].value(forKey: "motivation") as! String
//                    var story = data[i].value(forKey: "story") as! String
                    var username = data[i].value(forKey: "username") as! String
                    
                    labelUsername.text = username
                    labelAge.text = String(age)
//                    textViewMotivation.text = motivation
//                    textViewStory.text = story
                    
//                    profile = Profile(achievement: "nil", age: age, motivation: motivation, story: story, username: username)
                    
                    print(data[i].value(forKey: "username") as! String)
                }
            }


        }
        
        
        //        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 108, height: 152)
        //
        //        collectionViewProfile.collectionViewLayout = layout
        
        collectionViewProfile.register(ProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        collectionViewProfile.delegate = self
        collectionViewProfile.dataSource = self
        
        textViewMotivation.isEditable = false
        textViewStory.isEditable = false
        
        collectionViewProfile.isScrollEnabled = false
        
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relapse = dummyData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        
        cell.labelRelapseTime.text = relapse.relapseTime
        cell.labelRelapseDate.text = relapse.relapseDate

        return cell
    }
    
    
}

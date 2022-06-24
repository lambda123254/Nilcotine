//
//  ProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 20/06/22.
//

import UIKit
import CloudKit

class ProfileViewController: UIViewController {
    
    var relapse: [Relapse] = []
    var profile: Profile?
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    var ckR = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet var collectionViewProfile: UICollectionView!
    
    @IBOutlet weak var textViewMotivation: UITextView!
    @IBOutlet weak var textViewStory: UITextView!
    
    @IBOutlet weak var tableRelapse: UITableView!
    
    var userIdForDb: CKRecord.ID?
    
    let df = DateFormatter()
    
    var timeString: String?
    var dayInSecond: Int?
    var timeInterval: DateInterval?
    var dateString: String?
    var duration: Double?
    var time: (Int,Int,Int)?
    var visited = false
    var visitedUserId: CKRecord.ID?
    var intervalArr: [String] = []
    var userId: CKRecord.ID?
    override func viewDidLoad() {
        super.viewDidLoad()
        if visited {self.navigationItem.rightBarButtonItem = nil}
        tableRelapse.dataSource = self
        tableRelapse.delegate = self
        
        if visited == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: .plain, target: self, action: #selector(editProfileButtonPressed))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 33, green: 127, blue: 112)
        }
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 33, green: 127, blue: 112)

        Task {
            let data = try? await ck.get(option: "all", format: "")
            
            if visited == false {
                userId = try? await ck.getUserID()
            }
            else {
                userId = visitedUserId
            }
            
            

            for i in 0 ..< data!.count {
                let value = data![i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {

//                    var achievement = data[i].value(forKey: "achievement") as! String
                    let age = data![i].value(forKey: "age") as! Int
                    var motivation = data![i].value(forKey: "motivation") as! String
                    var story = data![i].value(forKey: "story") as! String
                    let username = data![i].value(forKey: "username") as! String
                    
                    if motivation == "nil" {
                        motivation = "You haven't filled your motivation to quit yet"
                    }
                    else {
                        textViewStory.textColor = .black
                    }
                    
                    if story == "nil" {
                        story = "You haven't filled your story yet"
                        
                    }
                    else {
                        textViewMotivation.textColor = .black
                    }
                    
                    labelUsername.text = username
                    labelAge.text = String(age)
                    textViewMotivation.text = motivation
                    textViewStory.text = story

                    
//                    profile = Profile(achievement: "nil", age: age, motivation: motivation, story: story, username: username)
                    
                }
            }

        }
        
        df.timeZone = TimeZone.current
        df.dateFormat = "dd/MM/YY"

        
        Task {
            let dataRecord = try? await ckR.get(option: "all", format: "")
            
            if visited == false {
                userId = try? await ck.getUserID()
            }
            else {
                userId = visitedUserId
            }
            
            
            for i in 0 ..< dataRecord!.count {
                let value = dataRecord![i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {
                    let effort = dataRecord![i].value(forKey: "effort") as! String
                    let startDate = dataRecord![i].value(forKey: "startDate") as! Date
                    let endDate = dataRecord![i].value(forKey: "endDate") as! Date
                    
                    relapse.append(Relapse(relapseEffort: effort, startDate: startDate, endDate: endDate))
                    
                    dateString = df.string(from: Date())
                    timeInterval = DateInterval(start: startDate, end: endDate)
                    duration = timeInterval?.duration
                    dayInSecond = Int (duration!)
                    time = daysToHoursToMinutes(seconds: dayInSecond!)
                    
                    intervalArr.append(makeTimeString(days: time!.0, hours: time!.1, minutes: time!.2))
                }
                
            }
            print(makeTimeString(days: time!.0, hours: time!.1, minutes: time!.2))
            
            self.tableRelapse.reloadData()
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
        
    }
    
    @objc func editProfileButtonPressed() {
        let nextView = storyBoard.instantiateViewController(withIdentifier: "EditProfileView") as! EditProfileViewController
        self.navigationController?.pushViewController(nextView, animated: true)

    }
    
    func daysToHoursToMinutes(seconds: Int) -> (Int, Int, Int)
    {

        return (((seconds / 86400 )  ), ((seconds % 86400) / 3600 ), ((seconds % 3600) / 60 ))
      
    }
    
    func makeTimeString(days: Int, hours: Int, minutes: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", days)
        timeString += " days "
        timeString += String(format: "%02d", hours)
        timeString += " hours "
        timeString += String(format: "%02d", minutes)
        timeString += " minutes "
        
        return timeString
    }
    
    
    @IBAction func seeAllPressed(_ sender: UIButton) {
        let nextView = storyBoard.instantiateViewController(withIdentifier: "AllAchievementView") as! AllAchievementViewController
        nextView.userId = userId
        self.navigationController?.pushViewController(nextView, animated: true)
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
//  customize size collectionView
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 108, height: 152)
//    }
//}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        relapse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableRelapse.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        
        cell.labelRelapseTime.text = intervalArr[indexPath.row]
        cell.labelRelapseDate.text = df.string(from: relapse[indexPath.row].endDate)

        return cell
    }
    
    
}


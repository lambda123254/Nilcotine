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
    var sortedRelapse: [Relapse] = []
    var profile: Profile?
    
    var achievement = AchievementData()
    var iconNameUse : [String] = []
    var iconNameUseSorted: [String] = []
    var achievementBadgeShow: String?
    var achievementLabelShow: String?
    var isFetchingFinish = false
    var relapseDayIntervalArr: [Int] = []
    var relapseDayIntervalTimer = 0
    var timer: Timer = Timer()

    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    var ckR = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    var ckA = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Achievements")
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelTotalRelapse: UILabel!
    @IBOutlet weak var labelLongestStreak: UILabel!
    @IBOutlet var collectionViewProfile: UICollectionView!
    
    @IBOutlet weak var textViewMotivation: UITextView!
    @IBOutlet weak var textViewStory: UITextView!
    
    @IBOutlet weak var tableRelapse: UITableView!
    
    var userIdForDb: CKRecord.ID?
    
    let df = DateFormatter()
    let dfComplete = DateFormatter()

    var timeString: String?
    var dayInSecond: Int?
    var timeInterval: DateInterval?
    var dateString: String?
    var duration: Double?
    var time: (Int,Int,Int)?
    var visited = false
    var visitedUserId: CKRecord.ID?
    var intervalArr: [String] = []
    var intervalSortedArr: [String] = []
    
    var dateInterval : DateInterval?
    var interval : Double?
    var dayInterval : Int?
    var maxDayInterval : [Int] = []
    
    var userId: CKRecord.ID?
    
    var imageUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView(frame: CGRect(x: 158.67, y: 111.67, width: 75, height: 75))
                profileImageView.layer.borderWidth = 1.0
                profileImageView.layer.masksToBounds = true
                profileImageView.layer.borderColor = UIColor.white.cgColor
                profileImageView.layer.cornerRadius = image.bounds.width / 2
                profileImageView.clipsToBounds = true
        
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
            
            //Data Achievement
            let dataAchievement = try await ckA.get(option: "all", format: "")
            for i in 0 ..< dataAchievement.count {
                let value = dataAchievement[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {
                    
                    let iconName = dataAchievement[i].value(forKey: "iconName") as! String
                    
                    
                    iconNameUse.append(iconName)

                } // if
            }// for
            
            if iconNameUse.count > 3 {
                for i in 0 ..< 3 {
                    iconNameUse.append(iconNameUse[i])
                }
                iconNameUseSorted = iconNameUse.sorted()
            }
            else if iconNameUse.count < 3 {
                for i in 0 ..< 3 - iconNameUse.count {
                    iconNameUse.append("nil")
                }
                iconNameUseSorted = iconNameUse.sorted()
            }
            else if iconNameUse.count == 3 {
                iconNameUseSorted = iconNameUse.sorted()
            }
                        
            for i in 0 ..< data!.count {
                let value = data![i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {

//                    var achievement = data[i].value(forKey: "achievement") as! String
                    let age = data![i].value(forKey: "age") as! Int
                    var motivation = data![i].value(forKey: "motivation") as! String
                    var story = data![i].value(forKey: "story") as! String
                    let username = data![i].value(forKey: "username") as! String
                    if let profileAsset = data![i].value(forKey: "profilePicture") as? CKAsset,
                       let data = try? Data(contentsOf: profileAsset.fileURL!),
                       let image = UIImage(data: data) {
                        imageUrl = profileAsset.fileURL
                        profileImageView.image = image
                    }
                    
                    if motivation == "nil" {
                        motivation = "You haven't filled your motivation to quit yet"
                        
                    }
                    else {
                        textViewMotivation.textColor = .black
                    }
                    
                    if story == "nil" {
                        story = "You haven't filled your story yet"
                        
                        
                    }
                    else {
                        textViewStory.textColor = .black
                    }
                    
                    for i in 0 ..< sortedRelapse.count {
                        dateInterval = DateInterval(start: sortedRelapse[i].startDate, end: sortedRelapse[i].endDate)
                        interval = dateInterval?.duration
                        dayInterval = Int (interval!) / 86400
                        
                        maxDayInterval.append(dayInterval!)
                        
                    }
                    
                    labelUsername.text = username
                    labelAge.text = String(age)
                    
                    if sortedRelapse.count == 0 {
                        labelTotalRelapse.text = "0"
                    } else {
                        labelTotalRelapse.text = "\(sortedRelapse.count - 1)"
                    }

                    
                    if maxDayInterval.max() == nil {
                        labelLongestStreak.text = "0"
                    }
                    else {
                        labelLongestStreak.text = "\(maxDayInterval.max()!)"
                    }

                    textViewMotivation.text = motivation
                    textViewStory.text = story
                    
                    
//                    profile = Profile(achievement: "nil", age: age, motivation: motivation, story: story, username: username)
                    
                }
            }
            isFetchingFinish = true
        }
        
//        df.timeZone = TimeZone.current
        df.dateFormat = "dd/MM/YYYY"

        dfComplete.dateFormat = "MM-dd-yyyy HH:mm"
        
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
                    
                    dateString = df.string(from: Date())
                    timeInterval = DateInterval(start: startDate, end: endDate)
                    duration = timeInterval?.duration
                    dayInSecond = Int (duration!)
                    time = daysToHoursToMinutes(seconds: dayInSecond!)
                    
                    relapse.append(Relapse(relapseEffort: effort, startDate: startDate, endDate: endDate, intervalTime: makeTimeString(days: time!.0, hours: time!.1, minutes: time!.2)))
                    
                    sortedRelapse = relapse.sorted(by: {$0.endDate > $1.endDate})
                    
                    intervalArr.append(makeTimeString(days: time!.0, hours: time!.1, minutes: time!.2))
                    
                    relapseDayIntervalArr.append(dayInSecond! / 86400)

                }
                
            }
    
            self.tableRelapse.reloadData()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(afterAsync), userInfo: nil, repeats: true)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 172)
        
        collectionViewProfile.collectionViewLayout = layout
        
        collectionViewProfile.register(ProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        collectionViewProfile.delegate = self
        collectionViewProfile.dataSource = self
        
        textViewMotivation.isEditable = false
        textViewStory.isEditable = false
        
        collectionViewProfile.isScrollEnabled = false
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }

    @objc func afterAsync() {
        if isFetchingFinish {
            collectionViewProfile.reloadData()
            timer.invalidate()
            
        }
        
    }
    
    @objc func editProfileButtonPressed() {
        let nextView = storyBoard.instantiateViewController(withIdentifier: "EditProfileView") as! EditProfileViewController
        nextView.imageFileUrl = imageUrl as NSURL?
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
    
    func intervalDays(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)
        return dayInterval.day!
    }
    
    
    @IBAction func seeAllPressed(_ sender: UIButton) {
        let nextView = storyBoard.instantiateViewController(withIdentifier: "AllAchievementView") as! AllAchievementViewController
        nextView.userId = userId
        nextView.visited = visited
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
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        achievementBadgeShow = achievement.data[indexPath.row].achievementImage
        achievementLabelShow = achievement.data[indexPath.row].achievementName
        
        if isFetchingFinish {
            cell.userIdLabel.text = userId?.recordName
//            print("\(iconNameUseSorted[indexPath.row]) == \(achievementBadgeShow!) \(visited)")
            if !visited {
                if iconNameUseSorted[indexPath.row] == achievementBadgeShow {
                    cell.AchievementImage.image = UIImage(named: "\(achievementBadgeShow!)")
                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                }
                else if iconNameUseSorted[indexPath.row] != achievementBadgeShow && !visited{
                    if relapseDayIntervalArr.count == 0 {
                        cell.AchievementImage.image = UIImage(named: "Achievement Locked.png")
                        cell.AchievementLabel.text = "\(achievementLabelShow!)"
                    }
                    else {
                        for i in 0 ..< relapseDayIntervalArr.count {
                            if relapseDayIntervalTimer > relapseDayIntervalArr[i] {
                                if relapseDayIntervalTimer > achievement.data[indexPath.row].isClaimableDays {
                                    cell.claimButton.isHidden = false
                                    cell.AchievementImage.image = UIImage(named: "\(achievementBadgeShow!)")
                                    cell.AchievementImage.restorationIdentifier = achievementBadgeShow!
                                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                                    cell.ClaimButtonTapped = {
                                        let nextView = self.storyBoard.instantiateViewController(withIdentifier: "AchievementFormView") as! AchievementFormViewController
                                        nextView.userIdString = cell.userIdLabel.text!
                                        nextView.achievementImageString = cell.AchievementImage.restorationIdentifier!
                                        nextView.achievementName = cell.AchievementLabel.text!
                                        self.navigationController?.pushViewController(nextView, animated: true)
                                    }
                                    
                                    for j in 0 ..< iconNameUseSorted.count {
                                        if iconNameUseSorted[j] == achievementBadgeShow {
                                            cell.claimButton.isHidden = true
                                        }
                                    }
                                }
                                else {
                                    cell.AchievementImage.image = UIImage(named: "Achievement Locked.png")
                                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                                }
                            }
                            else {
                                if relapseDayIntervalArr.max()! >= achievement.data[indexPath.row].isClaimableDays {
                                    cell.claimButton.isHidden = false
                                    cell.AchievementImage.image = UIImage(named: "\(achievementBadgeShow!)")
                                    cell.AchievementImage.restorationIdentifier = achievementBadgeShow!
                                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                                    cell.ClaimButtonTapped = {
                                        let nextView = self.storyBoard.instantiateViewController(withIdentifier: "AchievementFormView") as! AchievementFormViewController
                                        nextView.userIdString = cell.userIdLabel.text!
                                        nextView.achievementImageString = cell.AchievementImage.restorationIdentifier!
                                        nextView.achievementName = cell.AchievementLabel.text!
                                        self.navigationController?.pushViewController(nextView, animated: true)
                                    }
                                    
                                    for j in 0 ..< iconNameUseSorted.count {
                                        if iconNameUseSorted[j] == achievementBadgeShow {
                                            cell.claimButton.isHidden = true
                                        }
                                    }
                                }
                                else {
                                    cell.AchievementImage.image = UIImage(named: "Achievement Locked.png")
                                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                                }
                            }
                        }
                    }
                    
                }

            }
            else {
                
                cell.AchievementImage.image = UIImage(named: "Achievement Locked.png")
                cell.AchievementLabel.text = "\(achievementLabelShow!)"
                for i in 0 ..< iconNameUseSorted.count {
                    if iconNameUseSorted[i] == achievementBadgeShow! {
                        cell.AchievementImage.image = UIImage(named: "\(achievement.data[0].achievementImage)")
                        cell.AchievementLabel.text = "\(achievementLabelShow!)"
                    }
                }
                
            }
            

        }
        
        return cell
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetailViewController
        nextView.titleLabelString = "You relapsed"
        nextView.daysLabelString = "After \(sortedRelapse[indexPath.row].intervalTime)"
        nextView.effortTextViewString = sortedRelapse[indexPath.row].relapseEffort
        nextView.effortTextColor = UIColor.black
        nextView.activityDetailImage = UIImage(named: "Relapse.png")!
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedRelapse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableRelapse.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        
        cell.selectionStyle = .none
        cell.labelRelapseTime.text = sortedRelapse[indexPath.row].intervalTime
        cell.labelRelapseDate.text = df.string(from: sortedRelapse[indexPath.row].endDate)

        return cell
    }
    
    
}


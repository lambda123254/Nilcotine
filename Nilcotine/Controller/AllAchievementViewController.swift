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
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Achievements")
    var ckRelapse = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")

    var iconNameUse : [String] = []
    var iconNameUseSorted: [String] = []
    var sortedRelapse: [Relapse] = []
    var relapse: [Relapse] = []
    var achievementStoryArr: [[String]] = []
    var achievementStoryArrSorted: [[String]] = []


    var isFetchingFinish = false
    var timer: Timer = Timer()
    var userId: CKRecord.ID?
    var userIdString = ""
    
    var relapseDayIntervalArr: [Int] = []
    var relapseDayIntervalTimer = 0
    var visited = false
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
    @IBOutlet weak var AchievementCollection: UICollectionView!
    
    //let achievement = AchievementData()
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            
            //Data Achievement
            let data = try await ck.get(option: "all", format: "")
            let dataRelapse = try await ckRelapse.get(option: "all", format: "")
            for i in 0 ..< data.count {

                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {
                    
                    let iconName = data[i].value(forKey: "iconName") as! String
                    let achievementEffort = data[i].value(forKey: "story") as! String
                    let achievementName = data[i].value(forKey: "achievementName") as! String
                    
                    iconNameUse.append(iconName)
                    achievementStoryArr.append([achievementEffort,achievementName])

                } // if
            }// for
            
            //Data Relapse
            for i in 0 ..< dataRelapse.count {

                let value = dataRelapse[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {
                    let startDate = dataRelapse[i].value(forKey: "startDate") as! Date
                    let endDate = dataRelapse[i].value(forKey: "endDate") as! Date
                    
                    let timeInterval = DateInterval(start: startDate, end: endDate)
                    let duration = Int(timeInterval.duration)
                    relapse.append(Relapse(relapseEffort: "nil", startDate: startDate, endDate: endDate, intervalTime: "nil"))
                    
                    relapseDayIntervalArr.append(duration / 86400)
                    
                    sortedRelapse = relapse.sorted(by: {$0.startDate > $1.startDate})
                    
                } // if
            }// for
            
            for i in 0 ..< achievement.data.count - iconNameUse.count {
                iconNameUse.append("nil")
            }
            
            for i in 0 ..< achievement.data.count - achievementStoryArr.count {
                achievementStoryArr.append(["nil", "nil"])
            }
            let timeInterval = DateInterval(start: sortedRelapse.first!.startDate, end: Date())
            let duration = Int(timeInterval.duration)
            relapseDayIntervalTimer = duration / 86400
            
            iconNameUseSorted = iconNameUse.sorted()
            achievementStoryArrSorted = achievementStoryArr.sorted(by: {$0[1] < $1[1]})
            isFetchingFinish = true
        } // TASK END
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(afterAsync), userInfo: nil, repeats: true)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 172)
        AchievementCollection.collectionViewLayout = layout
        
        AchievementCollection.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        
        AchievementCollection.delegate = self
        AchievementCollection.dataSource = self

        
    }
    
    @objc func afterAsync() {
        if isFetchingFinish {
            AchievementCollection.reloadData()
            timer.invalidate()
            
        }
        
    }
    
    // Collection View Function
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! AchievementCollectionViewCell
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "AchievementFormView") as! AchievementFormViewController
        nextView.titleLabelString = "Yes, you did it!"
//        let stringDaysFromAchievement = "\(achievement.data[indexPath.row].achievementName)"
//        let index = stringDaysFromAchievement.firstIndex(of: " ") ?? stringDaysFromAchievement.endIndex
//        let achievementDaysLabel = stringDaysFromAchievement[..<index]
//        nextView.daysLabelString = "You earn trophy for completing \(achievementDaysLabel) days of no smoking"
        nextView.daysLabelString = "You earn trophy for completing \(achievement.data[indexPath.row].isClaimableDays) days of no smoking"
        
        print(achievementStoryArrSorted[1][1])
        for i in 0 ..< achievementStoryArrSorted.count {
            if achievementStoryArrSorted[i][1] == achievement.data[indexPath.row].achievementName {
                print(achievementStoryArrSorted[i][0])
                nextView.effortTextViewString = "\(achievementStoryArrSorted[indexPath.row][0])"
            }

        }
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    // return berapa kali rownya muncul
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return achievement.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.identifier, for: indexPath) as! AchievementCollectionViewCell
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        // TODO logic achievement unlock sama lock
        // Tampung data tampungan buat gambar2 badge biar bisa bandingin
        
        // user click, ngecheck ambil gambarnya apakah ke lock atau bukan. kalo lock, gaterjadi apa", tapi kalo ga ke lock, bs di navigate
        achievementBadgeShow = achievement.data[indexPath.row].achievementImage
        achievementLabelShow = achievement.data[indexPath.row].achievementName
        
        if isFetchingFinish {
            cell.userIdLabel.text = userId?.recordName

            if !visited {
                if iconNameUseSorted[indexPath.row] == achievementBadgeShow {
                    cell.AchievementImage.image = UIImage(named: "\(achievementBadgeShow!)")
                    cell.AchievementLabel.text = "\(achievementLabelShow!)"
                }
                else if iconNameUseSorted[indexPath.row] != achievementBadgeShow && !visited{
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
                            if relapseDayIntervalArr[i] >= achievement.data[indexPath.row].isClaimableDays {
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
            else {
                cell.AchievementImage.image = UIImage(named: "Achievement Locked.png")
                cell.AchievementLabel.text = "\(achievementLabelShow!)"
                for i in 0 ..< iconNameUseSorted.count {
                    if iconNameUseSorted[i] == achievementBadgeShow! {
                        print("aaa")
                        cell.AchievementImage.image = UIImage(named: "\(achievement.data[0].achievementImage)")
                        cell.AchievementLabel.text = "\(achievementLabelShow!)"
                    }
                }
                
            }
            

        }
        
        return cell
    }

}

// Customize Collection View
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 172)
    }

}

/*
 Table Achievement
 if userID di achievement = nil
 gambar lock
 
 else
 show badge
 
 
 
 */

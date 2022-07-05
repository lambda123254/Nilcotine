//
//  ActivityViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 13/06/22.
//

import UIKit
import CloudKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableActivity: UITableView!
    
    var activity: [Activity] = []
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")
    var userIdArr: [String] = []
    var sortedActivity: [Activity] = []
    let df = DateFormatter()
    

    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("refresh")
        self.tableActivity.reloadData()
        Task {
            let dataRecord = try? await ck.get(option: "all", format: "")
            
            for i in 0 ..< dataRecord!.count {
                let activityType = dataRecord![i].value(forKey: "activityType") as! String
                let username = dataRecord![i].value(forKey: "username") as! String
                let imageName = dataRecord![i].value(forKey: "imageName") as! String
                let age = 12
                let relapseStory = dataRecord![i].value(forKey: "relapseStory") as! String
                let trophyStory = dataRecord![i].value(forKey: "trophyStory") as! String
                let userId = dataRecord![i].value(forKey: "accountNumber") as! CKRecord.Reference
                userIdArr.append(userId.recordID.recordName)
                
                if dataRecord?[i].value(forKey: "startDate") == nil {
                    let isoDate = "2016-04-14T10:44:00+0000"

                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from:isoDate)!
                    activity.append(Activity( userId: userId.recordID.recordName, activityType: activityType, username: username, imageName: imageName, age: age, startDate: date, endDate: date, relapseStory: relapseStory, trophyStory: trophyStory))
                }
                else {
                    let startDate = dataRecord?[i].value(forKey: "startDate") as! Date
                    let endDate = dataRecord?[i].value(forKey: "endDate") as! Date
                    activity.append(Activity( userId: userId.recordID.recordName,activityType: activityType, username: username, imageName: imageName, age: age, startDate: startDate, endDate: endDate, relapseStory: relapseStory, trophyStory: trophyStory))
                }

                sortedActivity = activity.sorted(by: {$0.endDate > $1.endDate})

            }
            
            self.tableActivity.reloadData()
        }
        print("refreshdone")
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableActivity.dataSource = self
        tableActivity.delegate = self
        
//        tableActivity.refreshControl = refreshControl
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        tableView.addSubview(refreshControl) // not required when using UITableViewControll
        
        df.timeZone = TimeZone.current
        df.dateFormat = "MMM dd"
        

        Task {
            let dataRecord = try? await ck.get(option: "all", format: "")
            
            for i in 0 ..< dataRecord!.count {
                let activityType = dataRecord![i].value(forKey: "activityType") as! String
                let username = dataRecord![i].value(forKey: "username") as! String
                let imageName = dataRecord![i].value(forKey: "imageName") as! String
                let age = 12
                let relapseStory = dataRecord![i].value(forKey: "relapseStory") as! String
                let trophyStory = dataRecord![i].value(forKey: "trophyStory") as! String
                let userId = dataRecord![i].value(forKey: "accountNumber") as! CKRecord.Reference
                userIdArr.append(userId.recordID.recordName)
                
                if dataRecord?[i].value(forKey: "startDate") == nil {
                    let isoDate = "2016-04-14T10:44:00+0000"

                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from:isoDate)!
                    activity.append(Activity( userId: userId.recordID.recordName, activityType: activityType, username: username, imageName: imageName, age: age, startDate: date, endDate: date, relapseStory: relapseStory, trophyStory: trophyStory))
                }
                else {
                    let startDate = dataRecord?[i].value(forKey: "startDate") as! Date
                    let endDate = dataRecord?[i].value(forKey: "endDate") as! Date
                    activity.append(Activity( userId: userId.recordID.recordName,activityType: activityType, username: username, imageName: imageName, age: age, startDate: startDate, endDate: endDate, relapseStory: relapseStory, trophyStory: trophyStory))
                }

                sortedActivity = activity.sorted(by: {$0.endDate > $1.endDate})

            }
            
            self.tableActivity.reloadData()
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
            if #available(iOS 10.0, *) {
                tableActivity.refreshControl = refreshControl
            } else {
                tableActivity.backgroundView = refreshControl
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func intervalDays(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)
        return dayInterval.day!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedActivity.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableActivity.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell

        cell.selectionStyle = .none
        cell.labelName.text = sortedActivity[indexPath.row].username
        cell.labelDate.text = df.string(from: sortedActivity[indexPath.row].endDate)
        
        if sortedActivity[indexPath.row].activityType == "relapse" {
            cell.activityIconImageView.image = UIImage(named: "Icon Relapse.png")
            cell.ActivityTypeLabel.text = "Relapse"
            cell.ActivityTypeLabel.textColor = UIColor.black
            cell.ActivityTypeBackground.image = UIImage(named: "Rectangle-relapse.png")
            cell.ActivityCard.image = UIImage(named: "Card Relapse.png")
        } else {
            cell.activityIconImageView.image = UIImage (named: "Icon Achievement.png")
            cell.ActivityTypeLabel.text = "Achievement"
            cell.ActivityTypeLabel.textColor = UIColor.systemGreen
            cell.ActivityTypeBackground.image = UIImage(named: "Rectangle-achievement.png")
            cell.ActivityCard.image = UIImage(named: "Card Achievement.png")
            
        }
        
        
        
        
        //cell.userIdLabel.text = userIdArr[indexPath.row]
        if sortedActivity[indexPath.row].activityType == "relapse" {
            let df = DateFormatter()
            df.dateFormat = "YY/MM/dd"
            
            let calendar = Calendar.current

            let startDate = sortedActivity[indexPath.row].startDate
            let endDate = sortedActivity[indexPath.row].endDate
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)
            
            let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)
            
            //cell.labelDesc.text = "\(sortedActivity[indexPath.row].username) relapsed after \(dayInterval.day!) days of trying!"
            cell.labelDesc.text = "\(sortedActivity[indexPath.row].relapseStory)"
            cell.labelDesc.textColor = .black
        }
        else if sortedActivity[indexPath.row].activityType == "achievement" {
            //cell.labelDesc.text = "\(sortedActivity[indexPath.row].username) earn a throphy!"
            
            if sortedActivity[indexPath.row].trophyStory == "nil" {
                cell.labelDesc.text = "This user did not submit any story.."
                cell.labelDesc.textColor = .lightGray
            }// if
            else {
                cell.labelDesc.text = "\(sortedActivity[indexPath.row].trophyStory)"
                cell.labelDesc.textColor = .black
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let cell = tableView.cellForRow(at: indexPath) as! ActivityTableViewCell
        
        
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetailViewController
        nextView.userId = sortedActivity[indexPath.row].userId
        if sortedActivity[indexPath.row].activityType == "relapse" {
            nextView.titleLabelString = "\(sortedActivity[indexPath.row].username) has relapsed"
            nextView.daysLabelString = "\(intervalDays(startDate: sortedActivity[indexPath.row].startDate, endDate: sortedActivity[indexPath.row].endDate)) days of no smoking"
            nextView.activityDetailImage = UIImage(named: "Relapse.png")!
            
            if sortedActivity[indexPath.row].relapseStory == "nil"{
                nextView.effortTextViewString = "This user did not submit any story.."
                nextView.effortTextColor = UIColor.lightGray
            }
            else {
                nextView.effortTextViewString = sortedActivity[indexPath.row].relapseStory
                nextView.effortTextColor = UIColor.black

            }

            self.navigationController?.pushViewController(nextView, animated: true)
        }
        else {
            nextView.titleLabelString = "\(sortedActivity[indexPath.row].username) earn a trophy!"
            nextView.activityDetailImage = UIImage(named: "Achievement")!
            
            if sortedActivity[indexPath.row].trophyStory == "nil"{
                nextView.effortTextViewString = "This user did not submit any story.."
                nextView.effortTextColor = UIColor.lightGray
            }
            else {
                nextView.effortTextViewString = sortedActivity[indexPath.row].trophyStory
                nextView.effortTextColor = UIColor.black

            }
            
            
            
            self.navigationController?.pushViewController(nextView, animated: true)
            
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0x217F70)
        tableView.reloadData()
        
    }
    

    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

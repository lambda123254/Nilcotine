//
//  ActivityViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 13/06/22.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableActivity: UITableView!
    
    var activity: [Activity] = []
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableActivity.dataSource = self
        tableActivity.delegate = self

        Task {
            let dataRecord = try? await ck.get(option: "all", format: "")
            
            for i in 0 ..< dataRecord!.count {
                let activityType = dataRecord![i].value(forKey: "activityType") as! String
                let username = dataRecord![i].value(forKey: "username") as! String
                let imageName = dataRecord![i].value(forKey: "imageName") as! String
                let age = dataRecord![i].value(forKey: "userAge") as! Int
                let relapseStory = dataRecord![i].value(forKey: "relapseStory") as! String
                let trophyStory = dataRecord![i].value(forKey: "trophyStory") as! String

                
                if dataRecord?[i].value(forKey: "startDate") == nil {
                    let isoDate = "2016-04-14T10:44:00+0000"

                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from:isoDate)!
                    activity.append(Activity(activityType: activityType, username: username, imageName: imageName, age: age, startDate: date, endDate: date, relapseStory: relapseStory, trophyStory: trophyStory))
                }
                else {
                    let startDate = dataRecord?[i].value(forKey: "startDate") as! Date
                    let endDate = dataRecord?[i].value(forKey: "endDate") as! Date
                    activity.append(Activity(activityType: activityType, username: username, imageName: imageName, age: age, startDate: startDate, endDate: endDate, relapseStory: relapseStory, trophyStory: trophyStory))
                }

                

            }
            
            self.tableActivity.reloadData()
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
        return activity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableActivity.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell
        cell.labelName.text = activity[indexPath.row].username
        cell.labelAge.text = "\(activity[indexPath.row].age) yo"
        cell.activityIconImageView.image = UIImage(named: "ActivityIcon.png")
        if activity[indexPath.row].activityType == "relapse" {
            let df = DateFormatter()
            df.dateFormat = "YY/MM/dd"
            
            let calendar = Calendar.current

            let startDate = activity[indexPath.row].startDate
            let endDate = activity[indexPath.row].endDate
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)
            
            let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)

            cell.labelDesc.text = "\(activity[indexPath.row].username) relapsed after \(dayInterval.day!) days of trying!"
        }
        else if activity[indexPath.row].activityType == "badge" {
            cell.labelDesc.text = "\(activity[indexPath.row].username) earn a throphy!"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActivityTableViewCell
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetailViewController
        
        if activity[indexPath.row].activityType == "relapse" {
            nextView.titleLabelString = "\(activity[indexPath.row].username) has relapsed"
            nextView.daysLabelString = "\(intervalDays(startDate: activity[indexPath.row].startDate, endDate: activity[indexPath.row].endDate)) days of no smoking"
            
            if activity[indexPath.row].relapseStory == "nil"{
                nextView.effortTextViewString = "This user didn't submit any story.."
            }
            else {
                nextView.effortTextViewString = activity[indexPath.row].relapseStory

            }

            self.navigationController?.pushViewController(nextView, animated: true)
        }
        else {
            nextView.titleLabelString = "\(activity[indexPath.row].username) earn a trophy!"
            self.navigationController?.pushViewController(nextView, animated: true)
            
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0x217F70)
        
        
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

//
//  AchievementFormViewController.swift
//  Nilcotine
//
//  Created by Reza Mac on 26/06/22.
//

import UIKit
import CloudKit

protocol AllAchievementFormDelegateProtocol {
    func refresh()
}

class AchievementFormViewController: UIViewController {
    
    var delegate: AllAchievementFormDelegateProtocol? = nil

    var achievementName = ""
    var achievementImageString = ""
    var userIdString = ""

    
    var titleLabelString = ""
    var daysLabelString = ""
    var effortTextViewString = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!

    var userName = ""
    var firstDataForDb: String?
    var sortedData: [CKRecord] = []
    

    @IBOutlet weak var effortTextView: UITextView!
    @IBOutlet weak var achievementImageView: UIImageView!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Achievements")
    var ck2 = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")
    var ck3 = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(achievementName)
        // Do any additional setup after loading the view.
        

        effortTextView.isEditable = false
        titleLabel.text = titleLabelString
        daysLabel.text = daysLabelString
        effortTextView.text = effortTextViewString

        Task {
            
            let data = try await ck.get(option: "all", format: "")
            let dataProfile = try await ck3.get(option: "all", format: "")
            let userId = try await ck.getUserID()

            
            
            for i in 0 ..< dataProfile.count {
                let value = dataProfile[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    userName = dataProfile[i].value(forKey: "username") as! String
                    
                }
            } // For
            
        } // Task

    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        var effort = ""
        
        if effortTextView.text == "" || effortTextView.text == "Share your story here..."{
            effort = "nil"
        }
        else {
            effort = effortTextView.text
        }
        
        for i in 1 ... 2 {
            if i == 1 {
                ck.insertMultiple(value: "\(userIdString),\(effortTextView.text!),\(achievementName),\(achievementImageString)", key: "accountNumber,story,achievementName,iconName")
            } else {
                ck2.insertMultiple(value: "\(userIdString),achievement,\(Date()),achievement.png,nil,\(Date()),\(effort),\(userName)", key: "accountNumber,activityType,endDate,imageName,relapseStory,startDate,trophyStory,username")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
//    for i in 1 ... 2 {
//        if i == 1 {
//            ck.insertMultiple(value: "\(startTime),\(endTime),nil,\(userIdForDb!.recordName)" , key: "startDate,endDate,effort,accountNumber")
//        }
//        else {
//            ck2.insertMultiple(value: "\(userIdForDb!.recordName),relapse,\(endTime),relapse.png,\(effort), \(sortedData.first?.value(forKey: "startDate") as! Date),nil,\(userName)" , key: "accountNumber,activityType,endDate,imageName,relapseStory,startDate,trophyStory,username")
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

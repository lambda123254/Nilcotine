//
//  RelapseFormViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

import UIKit
import CloudKit

protocol RelapseFormDelegateProtocol {
    func refreshTimer()
}

class RelapseFormViewController: UIViewController, UITextViewDelegate {

    var delegate: RelapseFormDelegateProtocol? = nil
    @IBOutlet weak var RelapseTextView: UITextView!
    
    @IBOutlet weak var YouRelapsedLabel: UILabel!
    @IBOutlet weak var TellStoryLabel: UILabel!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    var ck2 = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")
    var ck3 = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")

    
    var firstDataForDb: String?
    var userIdForDb: CKRecord.ID?
    let df = DateFormatter()
    var userName = ""
    var sortedData: [CKRecord] = []
    var dayIntervalText: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.timeZone = TimeZone.current
       // df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        df.dateFormat = "dd"
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        RelapseTextView.text = "Share your story here..."
        RelapseTextView.textColor = UIColor.lightGray

        
        RelapseTextView.delegate = self
        
        Task{
            let data = try await ck.get(option: "all", format: "")
            let dataProfile = try await ck3.get(option: "all", format: "")
            let userId = try await ck.getUserID()
            userIdForDb = userId
            
            
            
            for i in 0 ..< data.count {
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    sortedData = data.sorted(by: {$0.value(forKey: "startDate") as! Date > $1.value(forKey: "startDate") as! Date})
                    
                    let firstData = sortedData.first?.recordID.recordName
                    firstDataForDb = firstData
                    
                    
                    // Get Last Date
                    
                    let lastDate = sortedData.first?.value(forKey: "startDate") as! Date

                    
                    dayIntervalText = lastDate
                    
                   
                }
            }
            
            for i in 0 ..< dataProfile.count {
                let value = dataProfile[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    userName = dataProfile[i].value(forKey: "username") as! String
                    
                }
            } // For
            
            
            // Change Calender
            let calendar = Calendar.current

            
            let startDate = dayIntervalText!
            let endDate = Date()
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)
            
            let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)
            
            YouRelapsedLabel.text = "You relapsed after \(dayInterval.day!) days"
            TellStoryLabel.text = "Tell your story how you can maintain \(dayInterval.day!) days streak"
            
            
        } // Task
        
       
        

        
    }
    
    func intervalDays(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let dayInterval = calendar.dateComponents([.day], from: date1, to: date2)
        return dayInterval.day!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your story here..."
            textView.textColor = UIColor.lightGray
        }
    }
    

    @IBAction func SubmitButtonPressed(_ sender: UIButton) {
        

        
        
        
        // if data = nil
        
        //Check if story contains "_"
        if RelapseTextView.text.contains("_") {
            let alert = UIAlertController(title: "Alert", message: "Remove '_' character in your story", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(_) in
                // dismiss
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if RelapseTextView.text == nil || RelapseTextView.text == "Share your story here..." || RelapseTextView
            .text == "" {
            
            let alert2 = UIAlertController(title: "Alert", message: "Relapse story must be filled !", preferredStyle: .alert)
            
            alert2.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(_) in
                // dismiss
                
            }))
           
            self.present(alert2, animated: true, completion: nil)
            
        }
        else {
            
            var effort = ""
            
            if RelapseTextView.text == "" || RelapseTextView.text == "Share your story here..."{
                effort = "nil"
            }
            else {
                effort = RelapseTextView.text
            }

            // Update the data

            ck.update(id: "\(firstDataForDb!)", value: "\(effort),\(Date())", key: "effort,endDate")
            for i in 1 ... 2 {
                if i == 1 {
                    ck.insertMultiple(value: "\(Date()),\(Date()),nil,\(userIdForDb!.recordName)" , key: "startDate,endDate,effort,accountNumber")
                }
                else {
                    ck2.insertMultiple(value: "\(userIdForDb!.recordName),relapse,\(Date()),relapse.png,\(effort),\(sortedData.first?.value(forKey: "startDate") as! Date),nil,\(userName)" , key: "accountNumber,activityType,endDate,imageName,relapseStory,startDate,trophyStory,username")
                }
            }
            
            self.delegate?.refreshTimer()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        }
    
    
    
    
  
    
    }
    

    



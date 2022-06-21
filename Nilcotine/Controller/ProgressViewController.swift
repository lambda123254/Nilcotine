
//  ProgressViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

// Todo : Make Tracker Live tracking even the app is closed
// Todo : Change relapse number and longest streak number
// Todo : Pass and save data to cloudkit

import UIKit
import CloudKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var TimerLabelDays: UILabel!
    @IBOutlet weak var TimerLabelHours: UILabel!
    @IBOutlet weak var TimerLabelMinutes: UILabel!
    
    @IBOutlet weak var RelapseNumber: UILabel!
    @IBOutlet weak var LongestStreakNumber: UILabel!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var RelapseButton: UIButton!
    
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false
    
    var dateInterval : DateInterval?
    var interval : Double?
    var dayInterval : Int?
    
    var maxDayInterval : [Int] = []
    
    
    
    var relapse: [Relapse] = []
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    
    var userIdForDb: CKRecord.ID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            // TODO : Get data from relapse database for total relapse + best attempt
            
            // Change Total Relapse Label
            let data = try await ck.get(option: "all", format: "")
            
            // Sort Data
            let sortedData = data.sorted(by: {$0.value(forKey: "startDate") as! Date > $1.value(forKey: "startDate") as! Date})
            
                                         
            let userId = try await ck.getUserID()
            userIdForDb = userId
            var countRecordId = 0
            for i in 0 ..< data.count {
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                
                    
                // Change Total Relapse Label ( need to be fixed )
                    
                    // ask : kok relapse numbernya ga berubah ya
                    countRecordId += 1
                    RelapseNumber.text = "\(countRecordId)"
                    
                // (check if it is best attempt ) Change Best Attempt Label
                    
                    let startDate = data[i].value(forKey: "startDate") as! Date
                    let endDate = data[i].value(forKey: "endDate") as! Date
                    let effort = data[i].value(forKey: "effort") as! String
                    
                    relapse = [Relapse(relapseEffort: effort, startDate: startDate, endDate: endDate)]
                    
                    
                    for i in 0 ..< relapse.count {
                        
                        dateInterval = DateInterval(start: relapse[i].startDate, end: relapse[i].endDate)
                        interval = dateInterval?.duration
                        dayInterval = Int (interval!) / 86400
                        print(dayInterval!)
                        
                        maxDayInterval.append(dayInterval!)
                        
                    }
                    
                    LongestStreakNumber.text = "\(maxDayInterval.max()!)"
                    
                    
                }
                
            } // for
            
            
            
            
        } // Task
  
        
    }
    
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        
        
        timerCounting = true
        StartButton.isHidden = true
        
        // Timer start counting
        // Set time interval = 60
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        let startTime = Date()
        let endTime = Date()

                
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd:HH:mm"
//        let result = dateFormatter.string(from: date)
//
//        print(result)
    

        
        
        ck.insertMultiple(value: "\(startTime),\(endTime),nil,\(userIdForDb!.recordName)" , key: "startDate,endDate,effort,accountNumber")


    }
    
    // Change label to timer
    @objc func timerCounter() -> Void
    {
        count = count+1
        let time = daysToHoursToMinutes(seconds: count)
        let timeStringDays = makeTimeStringDays(days: time.0)
        let timeStringHours = makeTimeStringHours(hours: time.1)
        let timeStringMinutes = makeTimeStringMinutes(minutes: time.2)
        
        TimerLabelDays.text = timeStringDays
        TimerLabelHours.text = timeStringHours
        TimerLabelMinutes.text = timeStringMinutes
        
    }
    
    func daysToHoursToMinutes(seconds: Int) -> (Int, Int, Int)
    {
        
       return (((seconds / 1440 )  ), ((seconds % 3600) / 60 % 24 ), ((seconds % 3600) % 60 ))
      
    }
    
    func makeTimeStringDays(days : Int) -> String
    {
        var timeStringDays = ""
        timeStringDays += String(format: "%02d", days)
        return timeStringDays
    }
    
    func makeTimeStringHours(hours : Int) -> String
    {
        var timeStringHours = ""
        timeStringHours += String(format: "%02d", hours)
        return timeStringHours
    }
    
    func makeTimeStringMinutes(minutes : Int) -> String
    {
        var timeStringMinutes = ""
        timeStringMinutes += String(format: "%02d", minutes)
        return timeStringMinutes
    }
    
    
    
    @IBAction func RelapseButonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Relapsing your progress", message: "Are you sure you want to start over all of your progress ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in
            // dismiss
            
        }))
        
        alert.addAction(UIAlertAction(title: "Relapse", style: .default, handler: {(_) in
            
      
        
            self.count = 0
            
            self.TimerLabelDays.text = self.makeTimeStringDays(days: 0)
            self.TimerLabelHours.text = self.makeTimeStringHours(hours: 0)
            self.TimerLabelMinutes.text = self.makeTimeStringMinutes(minutes: 0)
            
            self.timerCounting = false
            
            // Todo : Perform Segue to Relapse Form
            self.performSegue(withIdentifier: "toRelapseForm", sender: self)
            
            self.timerCounting = true
            
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    

    

}

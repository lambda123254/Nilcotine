
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

class ProgressViewController: UIViewController, RelapseFormDelegateProtocol {

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
    
    var sortedRelapse: [Relapse] = []
    
    var relapse: [Relapse] = []
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    
    var userIdForDb: CKRecord.ID?
    
    let df = DateFormatter()
    
    var isRelapseClicked = false
    var isLogin = false
    
    var time: (Int,Int,Int)?
    var timeStringDays: String?
    var timeStringHours: String?
    var timeStringMinutes: String?
    
    var dayInSecond: Int?
    var dateString: String?
    var timeInterval: DateInterval?
    var duration: Double?
    var countRecordId = 0

    var startInterval: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        Task {
            
            // Change Total Relapse Label
            let data = try await ck.get(option: "all", format: "")
            
            let userId = try await ck.getUserID()
            userIdForDb = userId
            for i in 0 ..< data.count {
                
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    if data[i].value(forKey: "startDate") != nil {
                        StartButton.isHidden = true
                        isLogin = true
                    }

                    
                // Change Total Relapse Label ( need to be fixed )
                    
                    // ask : kok relapse numbernya ga berubah ya
                    countRecordId += 1
                    RelapseNumber.text = "\(countRecordId - 1)"
                    
                // (check if it is best attempt ) Change Best Attempt Label
                    
                    let startDate = data[i].value(forKey: "startDate") as! Date
                    let endDate = data[i].value(forKey: "endDate") as! Date
                    let effort = data[i].value(forKey: "effort") as! String

                    relapse.append(Relapse(relapseEffort: effort, startDate: startDate, endDate: endDate))
                    sortedRelapse = relapse.sorted(by: {$0.startDate > $1.startDate})
                    startInterval = sortedRelapse.first?.startDate
                    for i in 0 ..< relapse.count {
                        dateInterval = DateInterval(start: relapse[i].startDate, end: relapse[i].endDate)
                        interval = dateInterval?.duration
                        dayInterval = Int (interval!) / 86400
                        
                        maxDayInterval.append(dayInterval!)
                        
                    }
                    LongestStreakNumber.text = "\(maxDayInterval.max()!)"
                    
                }
            } // for
            
            if isLogin {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            }

        } // Task
        
        
    }
    
    func refreshTimer() {
        isRelapseClicked = true
        timer.invalidate()
        count = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        countRecordId += 1
        RelapseNumber.text = "\(countRecordId)"

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC: RelapseFormViewController = segue.destination as! RelapseFormViewController
        secondVC.delegate = self
    }
    
    
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        
        
        timerCounting = true
        StartButton.isHidden = true
        
        // Timer start counting
        // Set time interval = 60
        isRelapseClicked = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        let startTime = df.string(from: Date())
        let endTime = df.string(from: Date())

        
        ck.insertMultiple(value: "\(startTime),\(endTime),nil,\(userIdForDb!.recordName)" , key: "startDate,endDate,effort,accountNumber")
        


    }
    
    // Change label to timer
    @objc func timerCounter() -> Void
    {
        
        
        if isRelapseClicked == false {
            dateString = df.string(from: Date())
            timeInterval = DateInterval(start: startInterval!, end: df.date(from: dateString!)!)
            duration = timeInterval?.duration
            dayInSecond = Int (duration!)
            time = daysToHoursToMinutes(seconds: dayInSecond!)

        }
        else {
            count += 1
            time = daysToHoursToMinutes(seconds: count)
        }
        

        timeStringDays = makeTimeStringDays(days: time!.0)
        timeStringHours = makeTimeStringHours(hours: time!.1)
        timeStringMinutes = makeTimeStringMinutes(minutes: time!.2)

        TimerLabelDays.text = timeStringDays
        TimerLabelHours.text = timeStringHours
        TimerLabelMinutes.text = timeStringMinutes
        
    }
    
    func daysToHoursToMinutes(seconds: Int) -> (Int, Int, Int)
    {

        return (((seconds / 86400 )  ), ((seconds % 86400) / 3600 ), ((seconds % 3600) / 60 ))
      
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
    
    // TODO : User pencet start sekali seumur hidup , gimana caranya buka aplikasi ga usah start

    

}

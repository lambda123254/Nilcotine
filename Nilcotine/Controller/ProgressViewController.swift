//
//  ProgressViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

// Todo : Make Tracker Live tracking even the app is closed
// Todo : Change relapse number and longest streak number
// Todo : Pass and save data to cloudkit

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var TimerLabelDays: UILabel!
    @IBOutlet weak var TimerLabelHours: UILabel!
    @IBOutlet weak var TimerLabelMinutes: UILabel!
    
    @IBOutlet weak var RelapseNumber: UILabel!
    @IBOutlet weak var LongestStreakNumber: UILabel!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var RelapseButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
    }
    
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        
        
        timerCounting = true
        StartButton.isHidden = true
        
        // Timer start counting
        // Set time interval = 60
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        

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
        // Todo : Fix Timerr ( Days , Hours , Minutes )
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

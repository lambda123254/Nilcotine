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
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    
    var firstDataForDb: String?
    var userIdForDb: CKRecord.ID?
    let df = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        RelapseTextView.text = "Share your story here..."
        RelapseTextView.textColor = UIColor.lightGray

        
        RelapseTextView.delegate = self
        
        Task{
            let data = try await ck.get(option: "all", format: "")
            let userId = try await ck.getUserID()
            userIdForDb = userId
            
            
            
            for i in 0 ..< data.count {
                let value = data[i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId.recordName {
                    
                    let sortedData = data.sorted(by: {$0.value(forKey: "startDate") as! Date > $1.value(forKey: "startDate") as! Date})
                    
                    let firstData = sortedData.first?.recordID.recordName
                    firstDataForDb = firstData
                    
                }
            }
            
        }
        
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
        
        let startTime = df.string(from: Date())
        let endTime = df.string(from: Date())
        var effort = ""
        
        if RelapseTextView.text == "" || RelapseTextView.text == "Share your story here..."{
            effort = "nil"
        }
        else {
            effort = RelapseTextView.text
        }

        // Update the data

        ck.update(id: "\(firstDataForDb!)", value: "\(effort),\(endTime)", key: "effort,endDate")

        ck.insertMultiple(value: "\(startTime),\(endTime),nil,\(userIdForDb!.recordName)" , key: "startDate,endDate,effort,accountNumber")
        
        
        // if data = nil
        
        //Check if story contains "_"
        if RelapseTextView.text.contains("_") {
            let alert = UIAlertController(title: "Alert", message: "Remove '_' character in your story", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(_) in
                // dismiss
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.delegate?.refreshTimer()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        }
    
    
    
    
  
    
    }
    

    



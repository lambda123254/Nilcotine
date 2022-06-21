//
//  RelapseFormViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

import UIKit
import CloudKit

class RelapseFormViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var RelapseTextView: UITextView!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    
    var firstDataForDb: String?
    var userIdForDb: CKRecord.ID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let startTime = Date()
        let endTime = Date()
    
        
        // Update the data

        ck.update(id: "\(firstDataForDb!)", value: "\(RelapseTextView.text!),\(endTime)", key: "effort,endDate")
        
        
        
        
        //TODO Insert new data cell for new relapse
        
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
            self.navigationController?.popViewController(animated: true)

        }
        
        }
    
    
    
    
  
    
    }
    

    



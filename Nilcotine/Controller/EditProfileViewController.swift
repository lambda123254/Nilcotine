//
//  EditProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 21/06/22.
//

import UIKit
import CloudKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var pickerAge: UIPickerView!
    
    @IBOutlet weak var labelCountCharMotivation: UILabel!
    @IBOutlet weak var textViewMotivation: UITextView!
    
    @IBOutlet weak var labelCountCharStory: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var textViewStory: UITextView!
    var data: [String] = []
    
    var countTextViewStory = 0
    var countTextViewMotivation = 0
    var maxMotivationBool = false
    var maxStoryBool = false
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    var recordId: String?
    var age = 0
    var usernameString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))

        
        textViewMotivation.layer.borderColor = UIColor.lightGray.cgColor
        textViewMotivation.layer.borderWidth = 1
        textViewMotivation.layer.cornerRadius = 10
        
        textViewStory.layer.borderColor = UIColor.lightGray.cgColor
        textViewStory.layer.borderWidth = 1
        textViewStory.layer.cornerRadius = 10
        
        textViewMotivation.text = "Type your motivation to stop nicotine consumption."
        textViewMotivation.textColor = UIColor.lightGray
        textViewStory.text = "Tell the story of your nicotine consumption and journey so far."
        textViewStory.textColor = UIColor.lightGray
        
        for i in 1 ... 99 {
            data.append(String(i))
        }

        pickerAge.dataSource = self
        pickerAge.delegate = self
        
        textViewMotivation.delegate = self
        textViewStory.delegate = self
        
        Task {
            let data = try? await ck.get(option: "all", format: "")
            let userId = try? await ck.getUserID()
            for i in 0 ..< data!.count {
                let value = data![i].value(forKey: "accountNumber") as! CKRecord.Reference
                if value.recordID.recordName == userId!.recordName {
                    recordId = data![i].recordID.recordName
                    usernameString = data![i].value(forKey: "username") as! String
                }
            }
        }
    }
    
    @objc func saveButtonPressed() {
        if textViewMotivation.text == "" {
            textViewMotivation.text = "nil"
        }
        if textViewStory.text == "" {
            textViewStory.text = "nil"
        }
        if usernameTextField.text == "" {
            usernameTextField.text = usernameString
        }
        ck.update(id: "\(recordId!)", value: "nil,\(age),\(textViewMotivation.text!),\(textViewStory.text!),\(usernameTextField.text!)", key: "achievement,age,motivation,story,username")
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age = pickerView.selectedRow(inComponent: component) + 1
    }
}

extension EditProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === textViewMotivation {
            if textViewMotivation.text.count > 150 {
                textViewMotivation.text = String(textViewMotivation.text.dropLast())
            }
            labelCountCharMotivation.text = String(textViewMotivation.text.count)

        }
        else if textView === textViewStory {
            if textViewStory.text.count > 250 {
                textViewStory.text = String(textViewStory.text.dropLast())
            }
            labelCountCharStory.text = String(textViewStory.text.count)
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
            if textView === textViewMotivation {
                textView.text = "Type your motivation to stop nicotine consumption."
                textView.textColor = UIColor.lightGray
            }
            
            else if textView === textViewStory {
                textView.text = "Tell the story of your nicotine consumption and journey so far."
                textView.textColor = UIColor.lightGray
            }
        }
    }
}



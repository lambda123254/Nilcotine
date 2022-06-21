//
//  EditProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 21/06/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var pickerAge: UIPickerView!
    
    @IBOutlet weak var labelCountCharMotivation: UILabel!
    @IBOutlet weak var textViewMotivation: UITextView!
    
    @IBOutlet weak var labelCountCharStory: UILabel!
    @IBOutlet weak var textViewStory: UITextView!
    var data: [String] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1 ... 99 {
            data.append(String(i))
        }

        pickerAge.dataSource = self
        pickerAge.delegate = self
        
        textViewMotivation.delegate = self
        textViewStory.delegate = self
        
        // Do any additional setup after loading the view.
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
}

extension EditProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        
//        let currentText2 = textViewStory.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
//        guard let stringRange2 = Range(range, in: currentText2) else {
//            return false
//        }

        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
//        let updateText2 = currentText2.replacingCharacters(in: stringRange2, with: text)
        
        labelCountCharMotivation.text = "\(updateText.count)"
//        labelCountCharStory.text = "\(updateText2.count)"
        
        return updateText.count < 150
//        return updateText2.count < 250
    }
}

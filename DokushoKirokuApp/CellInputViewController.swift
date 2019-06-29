//
//  CellInputViewController.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/25.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CellInputViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lastPageTextField: UITextField!
    
    var bookData: BookData!

    @IBAction func addDailyLogButton(_ sender: Any) {
        if let lastpage = lastPageTextField.text {
            if lastpage.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
            let dateString = formatter.string(from: datePicker.date)
            
            let currentUserId = Auth.auth().currentUser?.uid
            
            let dailyLogRef = Database.database().reference().child("user/" + currentUserId! + "/dailylog/" + bookData.id!)
            let dailyLogData = ["date": dateString, "last_page": lastpage]
            dailyLogRef.childByAutoId().setValue(dailyLogData)
            
            let bookRef = Database.database().reference().child("user/" + currentUserId! + "/book/" + bookData.id!)
            bookRef.updateChildValues(["last_page": lastpage])
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

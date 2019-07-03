//
//  ResetPasswordViewController.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/07/04.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailAddressTextField: UITextField!
    
    @IBAction func handleSendButton(_ sender: Any) {
        let email = mailAddressTextField.text ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("DEBUG_PRINT: " + error.localizedDescription)
                SVProgressHUD.showError(withStatus: "メール送信に失敗しました")
                return
            }
            
            print("DEBUG_PRINT: メール送信に成功しました。")
            SVProgressHUD.showError(withStatus: "パスワードリセット用のメールを送信しましたのでご確認ください")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAddressTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

//
//  InputViewController.swift
//  DokushoKirokuApp
//
//  Created by 原昂大 on 2019/06/25.
//  Copyright © 2019 takahiro.hara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class InputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var totalPagesTextField: UITextField!
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            self.bookImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBookDataButton(_ sender: Any) {
        if let title = titleTextField.text, let author = authorNameTextField.text, let totalpages = totalPagesTextField.text {
            if title.isEmpty || author.isEmpty || totalpages.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            let titleStrNum = title.count
            let authorStrNum = author.count
            if titleStrNum > 80 {
                SVProgressHUD.showError(withStatus: "タイトルは80文字以下にして下さい")
                return
            } else if authorStrNum > 20 {
                SVProgressHUD.showError(withStatus: "著者名は20文字以下にして下さい")
                return
            }
            
            let intTotalPages: Int = Int(totalpages)!
            if intTotalPages == 0 {
                SVProgressHUD.showError(withStatus: "総ページ数は0より大きい値として下さい")
                return
            }
            
            let imageData = bookImageView.image!.jpegData(compressionQuality: 0.5)
            let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
            let currentUserId = Auth.auth().currentUser?.uid
            
            let bookRef = Database.database().reference().child("user/" + currentUserId! + "/book")
            let bookData = ["title": title, "author": author, "total_pages": totalpages, "last_page": "0", "image": imageString]
            bookRef.childByAutoId().setValue(bookData)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        authorNameTextField.delegate = self
        
        let initialImage = UIImage(named: "booksample.png")
        bookImageView.image = initialImage
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

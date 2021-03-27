//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by 野田凜太郎 on 2021/03/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var registerButtun: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerButtun.layer.cornerRadius = 10
        registerButtun.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else { return } //keyboardMinYがoptional型だったのでguardとしてもし値がnilだったときにはこのfuncは終わらせる
        let registerButtunMaxY = registerButtun.frame.maxY
        let distance = registerButtunMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        } )
        
        
        print("keyboardFrame : ", keyboardMinY, "registerButtunMaxY: ", registerButtunMaxY)
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        } )
        print("hideKeyboard is hide")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //テキストボックス以外を触るとキーボードが引っ込む
    }


}

extension ViewController: UITextFieldDelegate {
    
    //textFieldのテキストを読み取る
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //isEmptyは値が何もなかったらtrueが帰る ?? trueはnilだったらtrueを返すっていう意味
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButtun.isEnabled = false
            registerButtun.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            registerButtun.isEnabled = true
            registerButtun.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }
}

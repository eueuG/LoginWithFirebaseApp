//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by 野田凜太郎 on 2021/03/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PKHUD

struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var registerButtun: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //registerbuttun押した時の処理がここで受け取れる
    @IBAction func tappedRegisterButtun(_ sender: Any) {
        handleAuthToFirebase()
        print("tappedRegisterButtun")
    }
    
    @IBAction func tappedAlresdyHaveAccountButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController((homeViewController), animated: true)
       // self.present(homeViewController, animated: true, completion: nil)
        
    }
    
    private func handleAuthToFirebase() {
        HUD.show(.progress, onView: view)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Cannot find 'Auth' in scope っていうエラーが出たのでここにFirebaseAuthをインポートして解決
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            
         //下のaddUser〜に移動しました
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            guard let name = self.usernameTextField.text else { return }
//            let docData = ["email": email, "name": name, "createdAt": Timestamp()] as [String : Any]
//            //配列の型をStringで指定、その後ろはAnyで指定
//
//            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
//                if let err = err {
//                    print("Firestoreへの保存に失敗しました。\(err)")
//                    return
//                }
//                print("Firestoreへの保存に成功しました。")
//            }
            self.addUserInfoToFirestore(email: email)
        }
    }
    
    private func addUserInfoToFirestore(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.usernameTextField.text else { return }
        let docData = ["email": email, "name": name, "createdAt": Timestamp()] as [String : Any]
        //配列の型をStringで指定、その後ろはAnyで指定
        
        //Firestoreのusersっていうところを参照してる変数
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました。")
            
            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide { (_) in
                        HUD.flash(.error, delay: 1)
                    }

                    return
                }
                
                //変数dataにuserRefからsnapshotで一時保存したデータを入れる。
                //それを使って構造体Userの型に入れる
                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)
                print("ユーザー情報の取得が出来ました。\(user.name)")
                HUD.hide { (_) in
                   // HUD.flash(.success, delay: 1)
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        self.presentToHomeViewController(user: user)
                    }
                }

            }
           
        }
        
    }
    
    private func presentToHomeViewController(user: User) {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as HomeViewController
        homeViewController.user = user
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerButtun.isEnabled = false
        registerButtun.layer.cornerRadius = 10
        registerButtun.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
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

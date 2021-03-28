//
//  HomeViewController.swift
//  LoginWithFirebaseApp
//
//  Created by 野田凜太郎 on 2021/03/28.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("user?.name: ",user?.name)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout() {//Call can throw, but it is not marked with 'try' and the error is not handled　が出ないようにdo try catchていう書き方をします
        do {
           try  Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました: \(err)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.cornerRadius = 10
        
        if let user = user { //ここでuserがnilじゃなかったら走るようにしてる
        nameLabel.text = user.name + "さんようこそ"
        emailLabel.text = user.email
        let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
        dateLabel.text = "作成日:  " + dateString
        }
    }
    
    private func dateFormatterForCreatedAt(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none //longにするともっと細かく出る
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}


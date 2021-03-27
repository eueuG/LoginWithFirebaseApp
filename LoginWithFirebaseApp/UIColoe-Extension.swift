//
//  UIColoe-Extension.swift
//  LoginWithFirebaseApp
//
//  Created by 野田凜太郎 on 2021/03/26.
//

import UIKit

extension UIColor { //元々あるUIColorというクラスに新しくメソッドを追加する
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
        //１がマックスで０〜１の間で変化するとかなんとか。指定されたRGBの値を上に入れれば使いやすいらしい
    }
    
    
}

//
//  LightTheme.swift
//  ThemeKit
//
//  Created by Sun on 2021/11/30.
//

import UIKit

class LightTheme: ITheme {
    let isLight = true
    let isDark = false
    
    let hudBlurStyle: UIBlurEffect.Style = .extraLight
    let keyboardAppearance: UIKeyboardAppearance = .light
    var statusBarStyle: UIStatusBarStyle = .darkContent

    let alphaSecondaryButtonGradient: CGFloat = 1
}

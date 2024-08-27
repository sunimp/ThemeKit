//
//  DarkTheme.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

class DarkTheme: ITheme {
    
    let isLight = false
    let isDark = true
    
    let hudBlurStyle: UIBlurEffect.Style = .dark
    let keyboardAppearance: UIKeyboardAppearance = .dark
    let statusBarStyle: UIStatusBarStyle = .lightContent

    let alphaSecondaryButtonGradient: CGFloat = 0.4
}

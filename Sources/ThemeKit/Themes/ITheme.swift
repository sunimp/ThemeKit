//
//  ITheme.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

public protocol ITheme {
    
    var isLight: Bool { get }
    var isDark: Bool { get }
    
    var hudBlurStyle: UIBlurEffect.Style { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var statusBarStyle: UIStatusBarStyle { get }

    var alphaSecondaryButtonGradient: CGFloat { get }
}

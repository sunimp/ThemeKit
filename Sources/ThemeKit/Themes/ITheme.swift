//
//  ITheme.swift
//
//  Created by Sun on 2021/11/30.
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

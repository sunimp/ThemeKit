//
//  SystemTheme.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

class SystemTheme: ITheme {
    var hudBlurStyle: UIBlurEffect.Style { UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .extraLight }
    var keyboardAppearance: UIKeyboardAppearance { .default }
    var statusBarStyle: UIStatusBarStyle { .default }

    var alphaSecondaryButtonGradient: CGFloat { UITraitCollection.current.userInterfaceStyle == .dark ? 0.4 : 1 }

}

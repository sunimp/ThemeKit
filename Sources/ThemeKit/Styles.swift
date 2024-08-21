//
//  Styles.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

extension UIBlurEffect.Style {
    public static var themeHud: UIBlurEffect.Style { Theme.current.hudBlurStyle }
}

extension UIStatusBarStyle {
    public static var themeDefault: UIStatusBarStyle { Theme.current.statusBarStyle }
}

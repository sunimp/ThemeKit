//
//  ThemeManager.swift
//
//  Created by Sun on 2021/11/30.
//

import Combine
import UIKit

import WWExtensions

// MARK: - ThemeManager

public class ThemeManager {
    // MARK: Static Properties

    public static var shared = ThemeManager()

    private static let defaultLightMode: ThemeMode = .system
    private static let userDefaultsKey = "theme_mode"

    // MARK: Properties

    private(set) var currentTheme: ITheme

    // MARK: Computed Properties

    @PostPublished
    public var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: ThemeManager.userDefaultsKey)
            currentTheme = ThemeManager.theme(mode: themeMode)
            Theme.updateNavigationBarTheme()
            Theme.updateTabBarTheme()
        }
    }

    // MARK: Lifecycle

    init() {
        var storedThemeMode: ThemeMode?
        if let newLightMode = UserDefaults.standard.value(forKey: ThemeManager.userDefaultsKey) as? String {
            storedThemeMode = ThemeMode(rawValue: newLightMode)
        }

        let themeMode = storedThemeMode ?? ThemeManager.defaultLightMode
        currentTheme = ThemeManager.theme(mode: themeMode)

        self.themeMode = themeMode
    }

    // MARK: Static Functions

    private static func theme(mode: ThemeMode) -> ITheme {
        switch mode {
        case .light: LightTheme()
        case .dark: DarkTheme()
        case .system: SystemTheme()
        }
    }
}

// MARK: - Theme

public class Theme {
    // MARK: Static Computed Properties

    public static var current: ITheme {
        ThemeManager.shared.currentTheme
    }

    // MARK: Static Functions

    public static func updateNavigationBarTheme(
        _ backgroundColor: UIColor = .zx009,
        textColor: UIColor = .zx001
    ) {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = UIImage()
        standardAppearance.backgroundColor = backgroundColor
        standardAppearance.backgroundImage = UIImage()
        standardAppearance.titleTextAttributes = [.foregroundColor: textColor]
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
    }
    
    public static func updateTabBarTheme(_ backgroundColor: UIColor = .zx009) {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = UIImage()
        standardAppearance.backgroundColor = backgroundColor
        standardAppearance.backgroundImage = UIImage()
        
        UITabBar.appearance().standardAppearance = standardAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = standardAppearance
        }
    }
}

// MARK: - ThemeMode

public enum ThemeMode: String {
    case light
    case dark
    case system
}

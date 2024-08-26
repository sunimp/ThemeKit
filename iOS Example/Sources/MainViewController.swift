//
//  MainViewController.swift
//  iOS Example
//
//  Created by Sun on 2024/8/23.
//

import UIKit
import SwiftUI

import ThemeKit

class MainViewController: ThemeTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableView.appearance().backgroundColor = .clear
        UICollectionView.appearance().backgroundColor = .clear
        
        let colorsVC = UIHostingController(rootView: ColorsView())
        let fontsVC = UIHostingController(rootView: FontsView())
        
        colorsVC.title = "Colors"
        colorsVC.view.backgroundColor = .clear
        let colorsItem = ThemeTabBarItem(
            title: "Colors",
            image: UIImage(systemName: "paintpalette")?.withRenderingMode(.alwaysTemplate)
        )
        colorsItem.badgeColor = .cg002
        colorsItem.badgeValue = ""
        colorsVC.tabBarItem = colorsItem
        
        fontsVC.title = "Fonts"
        fontsVC.view.backgroundColor = .clear
        let fontsItem = ThemeTabBarItem(
            title: "Fonts",
            image: UIImage(systemName: "textformat")?.withRenderingMode(.alwaysTemplate)
        )
        fontsItem.badgeColor = .cg002
        fontsItem.badgeValue = "87"
        fontsVC.tabBarItem = fontsItem
        
        let settingsVC = UIViewController(nibName: nil, bundle: nil)
        settingsVC.title = "Settings"
        settingsVC.view.backgroundColor = .clear
        let settingsItem = ThemeTabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysTemplate)
        )
        settingsItem.isEnabled = false
        settingsVC.tabBarItem = settingsItem
        
        let viewControllers: [UIViewController] = [
            ThemeNavigationController(rootViewController: colorsVC),
            ThemeNavigationController(rootViewController: fontsVC),
            ThemeNavigationController(rootViewController: settingsVC)
        ]
        
        setViewControllers(viewControllers, animated: false)
    }
}

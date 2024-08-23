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
        
        fontsVC.title = "Fonts"
        fontsVC.view.backgroundColor = .clear
        
        let colorsNav = ThemeNavigationController(rootViewController: colorsVC)
        let fontsNav = ThemeNavigationController(rootViewController: fontsVC)
        
        colorsNav.tabBarItem = ThemeTabBarItem(
            title: "Colors",
            image: UIImage(systemName: "paintpalette")?.withRenderingMode(.alwaysTemplate)
        )
        fontsNav.tabBarItem = ThemeTabBarItem(
            title: "Fonts",
            image: UIImage(systemName: "textformat")?.withRenderingMode(.alwaysTemplate)
        )
        let viewControllers: [UIViewController] = [
            colorsNav,
            fontsNav
        ]
        setViewControllers(viewControllers, animated: false)
    }
}

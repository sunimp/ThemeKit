//
//  ThemeControllers.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

import UIExtensions

// MARK: - ThemeNavigationController + IDeinitDelegate

extension ThemeNavigationController: IDeinitDelegate { }

// MARK: - ThemeTabBarController + IDeinitDelegate

extension ThemeTabBarController: IDeinitDelegate { }

// MARK: - ThemeViewController + IDeinitDelegate

extension ThemeViewController: IDeinitDelegate { }

// MARK: - ThemeNavigationController

open class ThemeNavigationController: UINavigationController {
    
    public var onDeinit: (() -> Void)?
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        tabBarItem = rootViewController.tabBarItem
        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    private func commonInit() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = .cg005
        updateUITheme()
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let top = topViewController, top.supportedInterfaceOrientations == .all {
            if top.presentedViewController != nil {
                return .portrait
            }
        }
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override open var childForStatusBarStyle: UIViewController? {
        topViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        topViewController
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = presentedViewController {
            return vc.preferredStatusBarStyle
        }
        return topViewController?.preferredStatusBarStyle ?? .themeDefault
    }

    override open var prefersStatusBarHidden: Bool {
        topViewController?.prefersStatusBarHidden ?? false
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationItem.searchController != nil {
            DispatchQueue.main.async {
                self.navigationBar.sizeToFit()
            }
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateUITheme()
    }
    
    private func updateUITheme() {
        navigationBar.shadowImage = UIImage()
    }
    
    deinit {
        onDeinit?()
    }
}

// MARK: - ThemeTabBarController

open class ThemeTabBarController: UITabBarController, ThemeTabBarDelegate {
    
    public typealias ShouldHijackHandler = (
        _ tabBarController: ThemeTabBarController,
        _ viewController: UIViewController,
        _ index: Int
    ) -> Bool
    
    public typealias HijackedHandler = (
        _ tabBarController: ThemeTabBarController,
        _ viewController: UIViewController,
        _ index: Int
    ) -> Void
    
    private var ignoreNextSelect = false
    
    public var shouldHijackHandler: ShouldHijackHandler?
    
    public var hijackedHandler: HijackedHandler?
    
    public var onDeinit: (() -> Void)?
    
    private lazy var themeTabBar = { () -> ThemeTabBar in
        let tabBar = ThemeTabBar()
        tabBar.delegate = self
        tabBar.customDelegate = self
        tabBar.tabBarController = self
        return tabBar
    }()
    
    override open var selectedViewController: UIViewController? {
        willSet {
            guard let newValue else {
                return
            }
            guard !ignoreNextSelect else {
                ignoreNextSelect = false
                return
            }
            guard
                let tabBar = tabBar as? ThemeTabBar,
                let index = viewControllers?.firstIndex(of: newValue)
            else {
                return
            }
            tabBar.select(itemAtIndex: index, animated: false)
        }
    }
    
    override open var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelect else {
                ignoreNextSelect = false
                return
            }
            guard let tabBar = tabBar as? ThemeTabBar else {
                return
            }
            tabBar.select(itemAtIndex: newValue, animated: false)
        }
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .themeDefault
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(themeTabBar, forKey: "tabBar")
        updateUITheme()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBar.superview?.setNeedsLayout()
    }
    
    override open func tabBar(_ tabBar: UITabBar, willBeginCustomizing _: [UITabBarItem]) {
        if let tabBar = tabBar as? ThemeTabBar {
            tabBar.updateLayout()
        }
    }
    
    override open func tabBar(_ tabBar: UITabBar, didEndCustomizing _: [UITabBarItem], changed _: Bool) {
        if let tabBar = tabBar as? ThemeTabBar {
            tabBar.updateLayout()
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateUITheme()
    }
    
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return
        }
        if let vc = viewControllers?[idx] {
            ignoreNextSelect = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            return shouldHijackHandler?(self, vc, idx) ?? false
        }
        return false
    }
    
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            hijackedHandler?(self, vc, idx)
        }
    }

    private func updateUITheme() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        themeTabBar.updateAppearance()
    }

    deinit {
        onDeinit?()
    }

}

// MARK: - ThemeViewController

open class ThemeViewController: UIViewController {
    
    public var onDeinit: (() -> Void)?

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.isDark ? .zx009 : .zx008
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .themeDefault
    }

    deinit {
        onDeinit?()
    }

}

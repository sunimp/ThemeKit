//
//  ThemeWindow.swift
//  ThemeKit
//
//  Created by Sun on 2021/11/30.
//

import Combine
import UIKit

open class ThemeWindow: UIWindow {
    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: Lifecycle

    override public init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        update(themeMode: ThemeManager.shared.themeMode)
        
        ThemeManager.shared.$themeMode
            .sink { [weak self] themeMode in
                self?.update(themeMode: themeMode)
            }
            .store(in: &cancellables)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func update(themeMode: ThemeMode) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            switch themeMode {
            case .system:
                self.overrideUserInterfaceStyle = .unspecified
            case .dark:
                self.overrideUserInterfaceStyle = .dark
            case .light:
                self.overrideUserInterfaceStyle = .light
            }
        }, completion: nil)
    }
}

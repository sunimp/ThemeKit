//
//  MainController.swift
//  ThemeKit-Example
//
//  Created by Sun on 2024/8/19.
//


import UIKit
import SwiftUI

import SnapKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainController = UIHostingController(rootView: MainView())

        addChild(mainController)
        view.addSubview(mainController.view)
        mainController.didMove(toParent: self)

        mainController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

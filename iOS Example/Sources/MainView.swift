//
//  MainView.swift
//  ThemeKit-Example
//
//  Created by Sun on 2024/8/19.
//

import SwiftUI

import ThemeKit

struct MainView: View {

    var body: some View {
        TabView {
            NavigationView {
                ColorsView()
                    .navigationTitle("Colors")
            }
            .tabItem {
                Image(systemName: "paintpalette")
                Text("Colors")
            }
            NavigationView {
                FontsView()
                        .navigationTitle("Fonts")
            }
                    .tabItem {
                        Image(systemName: "textformat")
                        Text("Fonts")
                    }
        }
                .accentColor(.cg005)
    }

}

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView()
    }

}

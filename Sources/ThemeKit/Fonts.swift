//
//  Fonts.swift
//  ThemeKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit
import SwiftUI

// SwiftUI
extension Font {
    
    public static let themeTitle1: Font = .roboto(size: 40, weight: .bold)
    public static let themeTitle2: Font = .roboto(size: 34, weight: .bold)
    public static let themeTitle2R: Font = .roboto(size: 34, weight: .regular)
    public static let themeTitle3: Font = .roboto(size: 22, weight: .bold)
    public static let themeTitle4: Font = .roboto(size: 20, weight: .bold)
    
    public static let themeHeadline1: Font = .roboto(size: 22, weight: .semibold)
    public static let themeHeadline2: Font = .roboto(size: 17, weight: .semibold)
    
    public static let themeBody: Font = .roboto(size: 17, weight: .regular)
    
    public static let themeSubhead1: Font = .roboto(size: 14, weight: .semibold)
    public static let themeSubhead1I: Font = .robotoItalic(size: 14)
    public static let themeSubhead2: Font = .roboto(size: 14, weight: .regular)
    
    public static let themeCaption: Font = .roboto(size: 12, weight: .regular)
    public static let themeCaptionSB: Font = .roboto(size: 12, weight: .semibold)
    
    public static let themeMicro: Font = .roboto(size: 10, weight: .regular)
    public static let themeMicroSB: Font = .roboto(size: 10, weight: .semibold)
}

extension Font {
    
    public static func roboto(size: CGFloat, weight: Font.Weight) -> Font {
        FontManager.registerRobotoFontsIfNeeded()
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Roboto-Bold"
        case .medium:
            fontName = "Roboto-Medium"
        default:
            fontName = "Roboto-Regular"
        }
        return Font.custom(fontName, size: size)
    }
    
    public static func robotoItalic(size: CGFloat) -> Font {
        FontManager.registerRobotoFontsIfNeeded()
        let fontName: String = "Roboto-Italic"
        return Font.custom(fontName, size: size)
    }
}

// UIKit
extension UIFont {
    
    public static let title1: UIFont = .roboto(size: 40, weight: .bold)
    public static let title2: UIFont = .roboto(size: 34, weight: .bold)
    public static let title2R: UIFont = .roboto(size: 34, weight: .regular)
    public static let title3: UIFont = .roboto(size: 22, weight: .bold)
    public static let title4: UIFont = .roboto(size: 20, weight: .bold)
    
    public static let headline1: UIFont = .roboto(size: 22, weight: .semibold)
    public static let headline2: UIFont = .roboto(size: 17, weight: .semibold)
    
    public static let body: UIFont = .roboto(size: 17, weight: .regular)
    
    public static let subhead1: UIFont = .roboto(size: 14, weight: .semibold)
    public static let subhead1I: UIFont = .robotoItalic(size: 14)
    public static let subhead2: UIFont = .roboto(size: 14, weight: .regular)
    
    public static let caption: UIFont = .roboto(size: 12, weight: .regular)
    public static let captionSB: UIFont = .roboto(size: 12, weight: .semibold)
    
    public static let micro: UIFont = .roboto(size: 10, weight: .regular)
    public static let microSB: UIFont = .roboto(size: 10, weight: .semibold)
}

extension UIFont {
    
    public static func roboto(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        FontManager.registerRobotoFontsIfNeeded()
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Roboto-Bold"
        case .medium:
            fontName = "Roboto-Medium"
        default:
            fontName = "Roboto-Regular"
        }
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size, weight: weight)
    }
    
    public static func robotoItalic(size: CGFloat) -> UIFont {
        FontManager.registerRobotoFontsIfNeeded()
        let fontName: String = "Roboto-Italic"
        return UIFont(name: fontName, size: size) ?? .italicSystemFont(ofSize: size)
    }
}

private enum FontManager {
    
    private static var isFontRegistered: Bool = false
    
    static func registerRobotoFontsIfNeeded() {
        if isFontRegistered {
            return
        }
        let fonts = [
            "Roboto-Bold",
            "Roboto-Medium",
            "Roboto-Regular",
            "Roboto-Italic",
        ]
        
        for font in fonts {
            guard let fontURL = Bundle.module.url(forResource: font, withExtension: "ttf") else {
                print("\(font).ttf not found.")
                continue
            }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            
            if let error {
                print("Font registration failed: \(error.takeUnretainedValue().localizedDescription)")
            }
        }
        isFontRegistered = true
    }
}

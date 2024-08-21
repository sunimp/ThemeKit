//
//  FontsView.swift
//  ThemeKit-Example
//
//  Created by Sun on 2024/8/19.
//

import SwiftUI

import ThemeKit

struct FontsView: View {

    private let groupingFonts: [GroupingFont] = [
        GroupingFont(group: .bold, fonts: [
            CustomFont(name: "bold6", font: .bold6),
            CustomFont(name: "bold7", font: .bold7),
            CustomFont(name: "bold8", font: .bold8),
            CustomFont(name: "bold9", font: .bold9),
            CustomFont(name: "bold10", font: .bold10),
            CustomFont(name: "bold11", font: .bold11),
            CustomFont(name: "bold12", font: .bold12),
            CustomFont(name: "bold13", font: .bold13),
            CustomFont(name: "bold14", font: .bold14),
            CustomFont(name: "bold15", font: .bold15),
            CustomFont(name: "bold16", font: .bold16),
            CustomFont(name: "bold17", font: .bold17),
            CustomFont(name: "bold18", font: .bold18),
            CustomFont(name: "bold19", font: .bold19),
            CustomFont(name: "bold20", font: .bold20),
            CustomFont(name: "bold22", font: .bold22),
            CustomFont(name: "bold24", font: .bold24),
            CustomFont(name: "bold26", font: .bold26),
            CustomFont(name: "bold28", font: .bold28),
            CustomFont(name: "bold30", font: .bold30),
            CustomFont(name: "bold31", font: .bold31),
            CustomFont(name: "bold32", font: .bold32),
            CustomFont(name: "bold34", font: .bold34),
            CustomFont(name: "bold36", font: .bold36),
            CustomFont(name: "bold40", font: .bold40),
            CustomFont(name: "bold42", font: .bold42),
            CustomFont(name: "bold44", font: .bold44),
            CustomFont(name: "bold48", font: .bold48),
            CustomFont(name: "bold56", font: .bold56)
        ]),
        GroupingFont(group: .medium, fonts: [
            CustomFont(name: "medium6", font: .medium6),
            CustomFont(name: "medium7", font: .medium7),
            CustomFont(name: "medium8", font: .medium8),
            CustomFont(name: "medium9", font: .medium9),
            CustomFont(name: "medium10", font: .medium10),
            CustomFont(name: "medium11", font: .medium11),
            CustomFont(name: "medium12", font: .medium12),
            CustomFont(name: "medium13", font: .medium13),
            CustomFont(name: "medium14", font: .medium14),
            CustomFont(name: "medium15", font: .medium15),
            CustomFont(name: "medium16", font: .medium16),
            CustomFont(name: "medium17", font: .medium17),
            CustomFont(name: "medium18", font: .medium18),
            CustomFont(name: "medium19", font: .medium19),
            CustomFont(name: "medium20", font: .medium20),
            CustomFont(name: "medium22", font: .medium22),
            CustomFont(name: "medium24", font: .medium24),
            CustomFont(name: "medium26", font: .medium26),
            CustomFont(name: "medium28", font: .medium28),
            CustomFont(name: "medium30", font: .medium30),
            CustomFont(name: "medium31", font: .medium31),
            CustomFont(name: "medium32", font: .medium32),
            CustomFont(name: "medium34", font: .medium34),
            CustomFont(name: "medium36", font: .medium36),
            CustomFont(name: "medium40", font: .medium40),
            CustomFont(name: "medium42", font: .medium42),
            CustomFont(name: "medium44", font: .medium44),
            CustomFont(name: "medium48", font: .medium48),
            CustomFont(name: "medium56", font: .medium56)
        ]),
        GroupingFont(group: .regular, fonts: [
            CustomFont(name: "regular6", font: .regular6),
            CustomFont(name: "regular7", font: .regular7),
            CustomFont(name: "regular8", font: .regular8),
            CustomFont(name: "regular9", font: .regular9),
            CustomFont(name: "regular10", font: .regular10),
            CustomFont(name: "regular11", font: .regular11),
            CustomFont(name: "regular12", font: .regular12),
            CustomFont(name: "regular13", font: .regular13),
            CustomFont(name: "regular14", font: .regular14),
            CustomFont(name: "regular15", font: .regular15),
            CustomFont(name: "regular16", font: .regular16),
            CustomFont(name: "regular17", font: .regular17),
            CustomFont(name: "regular18", font: .regular18),
            CustomFont(name: "regular19", font: .regular19),
            CustomFont(name: "regular20", font: .regular20),
            CustomFont(name: "regular22", font: .regular22),
            CustomFont(name: "regular24", font: .regular24),
            CustomFont(name: "regular26", font: .regular26),
            CustomFont(name: "regular28", font: .regular28),
            CustomFont(name: "regular30", font: .regular30),
            CustomFont(name: "regular31", font: .regular31),
            CustomFont(name: "regular32", font: .regular32),
            CustomFont(name: "regular34", font: .regular34),
            CustomFont(name: "regular36", font: .regular36),
            CustomFont(name: "regular40", font: .regular40),
            CustomFont(name: "regular42", font: .regular42),
            CustomFont(name: "regular44", font: .regular44),
            CustomFont(name: "regular48", font: .regular48),
            CustomFont(name: "regular56", font: .regular56)
        ]),
        GroupingFont(group: .italic, fonts: [
            CustomFont(name: "italic6", font: .italic6),
            CustomFont(name: "italic7", font: .italic7),
            CustomFont(name: "italic8", font: .italic8),
            CustomFont(name: "italic9", font: .italic9),
            CustomFont(name: "italic10", font: .italic10),
            CustomFont(name: "italic11", font: .italic11),
            CustomFont(name: "italic12", font: .italic12),
            CustomFont(name: "italic13", font: .italic13),
            CustomFont(name: "italic14", font: .italic14),
            CustomFont(name: "italic15", font: .italic15),
            CustomFont(name: "italic16", font: .italic16),
            CustomFont(name: "italic17", font: .italic17),
            CustomFont(name: "italic18", font: .italic18),
            CustomFont(name: "italic19", font: .italic19),
            CustomFont(name: "italic20", font: .italic20),
            CustomFont(name: "italic22", font: .italic22),
            CustomFont(name: "italic24", font: .italic24),
            CustomFont(name: "italic26", font: .italic26),
            CustomFont(name: "italic28", font: .italic28),
            CustomFont(name: "italic30", font: .italic30),
            CustomFont(name: "italic31", font: .italic31),
            CustomFont(name: "italic32", font: .italic32),
            CustomFont(name: "italic34", font: .italic34),
            CustomFont(name: "italic36", font: .italic36),
            CustomFont(name: "italic40", font: .italic40),
            CustomFont(name: "italic42", font: .italic42),
            CustomFont(name: "italic44", font: .italic44),
            CustomFont(name: "italic48", font: .italic48),
            CustomFont(name: "italic56", font: .italic56)
        ])
    ]

    var body: some View {
        List {
            ForEach(groupingFonts, id: \.group) { grouping in
                Section(header: Text(grouping.group.title)) {
                    ForEach(grouping.fonts, id: \.name) { font in
                        FontRow(name: font.name, font: font.font)
                    }
                }
            }
        }
    }

}

extension FontsView {

    private struct FontRow: View {
        var name: String
        var font: Font

        var body: some View {
            Text(name)
                    .font(font)
                    .padding(.margin8)
        }
    }

    private struct CustomFont: Hashable {
        let name: String
        let font: Font
    }

    private struct GroupingFont: Hashable {
        let group: FontGroup
        let fonts: [CustomFont]
    }
    
    private enum FontGroup: String, Hashable {
        case bold = "BOLD"
        case medium = "MEDIUM"
        case regular = "REGULAR"
        case italic = "ITALIC"
        
        var title: String {
            rawValue
        }
    }
}

struct FontsView_Previews: PreviewProvider {

    static var previews: some View {
        FontsView()
    }

}

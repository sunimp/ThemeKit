import SwiftUI

struct FontsView: View {

    private let groupingFonts: [GroupingFont] = [
        GroupingFont(group: .bold, fonts: [
            CustomFont(name: "bold6", font: .b6),
            CustomFont(name: "bold7", font: .b7),
            CustomFont(name: "bold8", font: .b8),
            CustomFont(name: "bold9", font: .b9),
            CustomFont(name: "bold10", font: .b10),
            CustomFont(name: "bold11", font: .b11),
            CustomFont(name: "bold12", font: .b12),
            CustomFont(name: "bold13", font: .b13),
            CustomFont(name: "bold14", font: .b14),
            CustomFont(name: "bold15", font: .b15),
            CustomFont(name: "bold16", font: .b16),
            CustomFont(name: "bold17", font: .b17),
            CustomFont(name: "bold18", font: .b18),
            CustomFont(name: "bold19", font: .b19),
            CustomFont(name: "bold20", font: .b20),
            CustomFont(name: "bold22", font: .b22),
            CustomFont(name: "bold24", font: .b24),
            CustomFont(name: "bold26", font: .b26),
            CustomFont(name: "bold28", font: .b28),
            CustomFont(name: "bold30", font: .b30),
            CustomFont(name: "bold31", font: .b31),
            CustomFont(name: "bold32", font: .b32),
            CustomFont(name: "bold34", font: .b34),
            CustomFont(name: "bold36", font: .b36),
            CustomFont(name: "bold40", font: .b40),
            CustomFont(name: "bold42", font: .b42),
            CustomFont(name: "bold44", font: .b44),
            CustomFont(name: "bold48", font: .b48),
            CustomFont(name: "bold56", font: .b56)
        ]),
        GroupingFont(group: .medium, fonts: [
            CustomFont(name: "medium6", font: .m6),
            CustomFont(name: "medium7", font: .m7),
            CustomFont(name: "medium8", font: .m8),
            CustomFont(name: "medium9", font: .m9),
            CustomFont(name: "medium10", font: .m10),
            CustomFont(name: "medium11", font: .m11),
            CustomFont(name: "medium12", font: .m12),
            CustomFont(name: "medium13", font: .m13),
            CustomFont(name: "medium14", font: .m14),
            CustomFont(name: "medium15", font: .m15),
            CustomFont(name: "medium16", font: .m16),
            CustomFont(name: "medium17", font: .m17),
            CustomFont(name: "medium18", font: .m18),
            CustomFont(name: "medium19", font: .m19),
            CustomFont(name: "medium20", font: .m20),
            CustomFont(name: "medium22", font: .m22),
            CustomFont(name: "medium24", font: .m24),
            CustomFont(name: "medium26", font: .m26),
            CustomFont(name: "medium28", font: .m28),
            CustomFont(name: "medium30", font: .m30),
            CustomFont(name: "medium31", font: .m31),
            CustomFont(name: "medium32", font: .m32),
            CustomFont(name: "medium34", font: .m34),
            CustomFont(name: "medium36", font: .m36),
            CustomFont(name: "medium40", font: .m40),
            CustomFont(name: "medium42", font: .m42),
            CustomFont(name: "medium44", font: .m44),
            CustomFont(name: "medium48", font: .m48),
            CustomFont(name: "medium56", font: .m56)
        ]),
        GroupingFont(group: .regular, fonts: [
            CustomFont(name: "regular6", font: .r6),
            CustomFont(name: "regular7", font: .r7),
            CustomFont(name: "regular8", font: .r8),
            CustomFont(name: "regular9", font: .r9),
            CustomFont(name: "regular10", font: .r10),
            CustomFont(name: "regular11", font: .r11),
            CustomFont(name: "regular12", font: .r12),
            CustomFont(name: "regular13", font: .r13),
            CustomFont(name: "regular14", font: .r14),
            CustomFont(name: "regular15", font: .r15),
            CustomFont(name: "regular16", font: .r16),
            CustomFont(name: "regular17", font: .r17),
            CustomFont(name: "regular18", font: .r18),
            CustomFont(name: "regular19", font: .r19),
            CustomFont(name: "regular20", font: .r20),
            CustomFont(name: "regular22", font: .r22),
            CustomFont(name: "regular24", font: .r24),
            CustomFont(name: "regular26", font: .r26),
            CustomFont(name: "regular28", font: .r28),
            CustomFont(name: "regular30", font: .r30),
            CustomFont(name: "regular31", font: .r31),
            CustomFont(name: "regular32", font: .r32),
            CustomFont(name: "regular34", font: .r34),
            CustomFont(name: "regular36", font: .r36),
            CustomFont(name: "regular40", font: .r40),
            CustomFont(name: "regular42", font: .r42),
            CustomFont(name: "regular44", font: .r44),
            CustomFont(name: "regular48", font: .r48),
            CustomFont(name: "regular56", font: .r56)
        ]),
        GroupingFont(group: .italic, fonts: [
            CustomFont(name: "italic6", font: .i6),
            CustomFont(name: "italic7", font: .i7),
            CustomFont(name: "italic8", font: .i8),
            CustomFont(name: "italic9", font: .i9),
            CustomFont(name: "italic10", font: .i10),
            CustomFont(name: "italic11", font: .i11),
            CustomFont(name: "italic12", font: .i12),
            CustomFont(name: "italic13", font: .i13),
            CustomFont(name: "italic14", font: .i14),
            CustomFont(name: "italic15", font: .i15),
            CustomFont(name: "italic16", font: .i16),
            CustomFont(name: "italic17", font: .i17),
            CustomFont(name: "italic18", font: .i18),
            CustomFont(name: "italic19", font: .i19),
            CustomFont(name: "italic20", font: .i20),
            CustomFont(name: "italic22", font: .i22),
            CustomFont(name: "italic24", font: .i24),
            CustomFont(name: "italic26", font: .i26),
            CustomFont(name: "italic28", font: .i28),
            CustomFont(name: "italic30", font: .i30),
            CustomFont(name: "italic31", font: .i31),
            CustomFont(name: "italic32", font: .i32),
            CustomFont(name: "italic34", font: .i34),
            CustomFont(name: "italic36", font: .i36),
            CustomFont(name: "italic40", font: .i40),
            CustomFont(name: "italic42", font: .i42),
            CustomFont(name: "italic44", font: .i44),
            CustomFont(name: "italic48", font: .i48),
            CustomFont(name: "italic56", font: .i56)
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

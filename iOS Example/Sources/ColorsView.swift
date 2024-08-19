import SwiftUI
import ThemeKit

struct ColorsView: View {
    @State private var currentMode = ThemeManager.shared.themeMode.rawValue
    @State private var themeModeIterator = 0

    private let groupingColors: [GroupingColor] = [
        GroupingColor(group: .cg, colors: [
            CustomColor(name: "CG001", color: .cg001),
            CustomColor(name: "CG002", color: .cg002),
            CustomColor(name: "CG003", color: .cg003),
            CustomColor(name: "CG004", color: .cg004),
            CustomColor(name: "CG005", color: .cg005),
            CustomColor(name: "CG006", color: .cg006),
            CustomColor(name: "CG007", color: .cg007),
            CustomColor(name: "CG009", color: .cg008)
        ]),
        GroupingColor(group: .fz, colors: [
            CustomColor(name: "FZ001", color: .fz001),
            CustomColor(name: "FZ002", color: .fz002),
            CustomColor(name: "FZ003", color: .fz003),
            CustomColor(name: "FZ004", color: .fz004),
            CustomColor(name: "FZ005", color: .fz005),
            CustomColor(name: "FZ006", color: .fz006),
            CustomColor(name: "FZ007", color: .fz007),
            CustomColor(name: "FZ008", color: .fz008),
            CustomColor(name: "FZ009", color: .fz009),
            CustomColor(name: "FZ010", color: .fz010),
            CustomColor(name: "FZ011", color: .fz011),
            CustomColor(name: "FZ012", color: .fz012),
            CustomColor(name: "FZ013", color: .fz013)
        ]),
        GroupingColor(group: .jd, colors: [
            CustomColor(name: "JD001", color: .jd001),
            CustomColor(name: "JD002", color: .jd002),
            CustomColor(name: "JD003", color: .jd003),
            CustomColor(name: "JD004", color: .jd004),
            CustomColor(name: "JD005", color: .jd005),
            CustomColor(name: "JD006", color: .jd006),
            CustomColor(name: "JD007", color: .jd007),
            CustomColor(name: "JD008", color: .jd008),
            CustomColor(name: "JD009", color: .jd009),
            CustomColor(name: "JD010", color: .jd010),
            CustomColor(name: "JD011", color: .jd011),
            CustomColor(name: "JD012", color: .jd012),
            CustomColor(name: "JD013", color: .jd013),
            CustomColor(name: "JD014", color: .jd014),
            CustomColor(name: "JD015", color: .jd015),
            CustomColor(name: "JD016", color: .jd016),
            CustomColor(name: "JD017", color: .jd017),
            CustomColor(name: "JD018", color: .jd018),
            CustomColor(name: "JD019", color: .jd019),
            CustomColor(name: "JD020", color: .jd020),
            CustomColor(name: "JD021", color: .jd021),
            CustomColor(name: "JD022", color: .jd022),
            CustomColor(name: "JD023", color: .jd023),
            CustomColor(name: "JD024", color: .jd024),
            CustomColor(name: "JD025", color: .jd025),
            CustomColor(name: "JD026", color: .jd026),
            CustomColor(name: "JD027", color: .jd027),
            CustomColor(name: "JD028", color: .jd028),
            CustomColor(name: "JD029", color: .jd029),
            CustomColor(name: "JD030", color: .jd030),
            CustomColor(name: "JD031", color: .jd031),
            CustomColor(name: "JD032", color: .jd032)
        ]),
        GroupingColor(group: .zx, colors: [
            CustomColor(name: "ZX001", color: .zx001),
            CustomColor(name: "ZX002", color: .zx002),
            CustomColor(name: "ZX003", color: .zx003),
            CustomColor(name: "ZX004", color: .zx004),
            CustomColor(name: "ZX005", color: .zx005),
            CustomColor(name: "ZX006", color: .zx006),
            CustomColor(name: "ZX007", color: .zx007),
            CustomColor(name: "ZX008", color: .zx008),
            CustomColor(name: "ZX009", color: .zx009),
            CustomColor(name: "ZX010", color: .zx010),
            CustomColor(name: "ZX011", color: .zx011),
            CustomColor(name: "ZX012", color: .zx012),
            CustomColor(name: "ZX013", color: .zx013),
            CustomColor(name: "ZX014", color: .zx014),
            CustomColor(name: "ZX015", color: .zx015),
            CustomColor(name: "ZX016", color: .zx016),
            CustomColor(name: "ZX017", color: .zx017),
            CustomColor(name: "ZX018", color: .zx018),
            CustomColor(name: "ZX019", color: .zx019)
        ]),
    ]

    var body: some View {
        List {
            ForEach(groupingColors, id: \.group) { grouping in
                Section(header: Text(grouping.group.title)) {
                    ForEach(grouping.colors, id: \.name) { color in
                        ColorRow(name: color.name, color: color.color)
                    }
                }
            }
        }
        .toolbar {
            Button(currentMode) {
                onTapToggle()
            }
        }
    }

    private func onTapToggle() {
        themeModeIterator += 1
        if themeModeIterator > 2 {
            themeModeIterator = 0
        }

        if themeModeIterator == 0 {
            ThemeManager.shared.themeMode = .system
            UIApplication.shared.windows.first(where: \.isKeyWindow)?.overrideUserInterfaceStyle = .unspecified
        }
        if themeModeIterator == 1 {
            ThemeManager.shared.themeMode = .dark
            UIApplication.shared.windows.first(where: \.isKeyWindow)?.overrideUserInterfaceStyle = .dark
        }
        if themeModeIterator == 2 {
            ThemeManager.shared.themeMode = .light
            UIApplication.shared.windows.first(where: \.isKeyWindow)?.overrideUserInterfaceStyle = .light
        }

        currentMode = ThemeManager.shared.themeMode.rawValue
    }

}

extension ColorsView {

    private struct ColorRow: View {
        var name: String
        var color: Color

        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: .cornerRadius8, style: .continuous)
                        .strokeBorder(.black, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: .cornerRadius8, style: .continuous).fill(color))
                        .frame(width: 60)
                        .padding(.margin8)
                Text(name)
                        .padding(.margin8)
            }
        }
    }

    private struct CustomColor: Hashable {
        let name: String
        let color: Color
    }
    
    private struct GroupingColor: Hashable {
        let group: ColorGroup
        let colors: [CustomColor]
    }

    private enum ColorGroup: String, Hashable {
        case cg = "CG"
        case fz = "FZ"
        case jd = "JD"
        case zx = "ZX"
        
        var title: String {
            rawValue
        }
    }
    
}

struct ColorsView_Previews: PreviewProvider {

    static var previews: some View {
        ColorsView()
    }

}

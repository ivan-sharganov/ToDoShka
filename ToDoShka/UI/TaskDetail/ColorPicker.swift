import SwiftUI
import CocoaLumberjackSwift

/// Представление с отображением текущего цвета на экране детаоей задачи
struct ColorPickerView: View {
    @State private var isColorPickerPresented = false
    @Binding var selectedColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Цвет")
                    .font(.system(size: 17))
                Text(selectedColor.toHex())
                    .font(
                        .system(size: 13)
                        .bold()
                    )
                    .foregroundColor(.blue)
            }
            Spacer()

            Circle()
                .fill(selectedColor)
                .frame(width: 25, height: 25)
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .onTapGesture {
                    isColorPickerPresented = true
                }
                .sheet(isPresented: $isColorPickerPresented) {
                    ColorPickerScreen(selectedColor: $selectedColor)
                }
        }
        .padding()
    }
}
/// Экран выбора цвета
struct ColorPickerScreen: View {
    @Binding var selectedColor: Color
    @State private var hue: Double = 0.0
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 1.0
    @State private var indicatorPosition: CGPoint = .zero
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            CustomColorPicker(hue: $hue, saturation: $saturation, brightness: $brightness, selectedColor: $selectedColor, indicatorPosition: $indicatorPosition)

            Button("Выбрать") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .onAppear {
            DDLogDebug("ColorPicker screen opened")
            let uiColor = UIColor(selectedColor)
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            self.hue = Double(h)
            self.saturation = Double(s)
            self.brightness = Double(b)

            let center = CGPoint(x: 150, y: 150)
            let radius = 150.0
            let angle = CGFloat(h) * 2 * .pi
            let dx = cos(angle - .pi / 2) * CGFloat(s) * radius
            let dy = Darwin.sin(angle - .pi / 2) * CGFloat(s) * radius
            self.indicatorPosition = CGPoint(x: center.x + dx, y: center.y + dy)
        }
    }
}

/// Представление с палитрой и слайдером
struct CustomColorPicker: View {

    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var selectedColor: Color
    @Binding var indicatorPosition: CGPoint

    var body: some View {
        VStack {
            ColorPalette(hue: $hue, saturation: $saturation, brightness: $brightness, selectedColor: $selectedColor, indicatorPosition: $indicatorPosition)
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .shadow(radius: 10)

            Slider(value: Binding(
                get: { self.brightness },
                set: { newValue in
                    self.brightness = newValue
                    self.selectedColor = Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness)
                }
            ), in: 0...1)
                .padding()
                .accentColor(selectedColor)

            Rectangle()
                .fill(selectedColor)
                .frame(height: 50)
                .padding()
        }
        .padding()
        .onAppear {
            let center = CGPoint(x: 150, y: 150)
            let radius = 150.0
            let dx = cos(0) * radius
            let dy = sin(0) * radius
            self.indicatorPosition = CGPoint(x: center.x + dx, y: center.y + dy)
        }
    }
}

/// Представление палитры
struct ColorPalette: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var selectedColor: Color
    @Binding var indicatorPosition: CGPoint

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let dimension = min(size.width, size.height)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = dimension / 2

            ZStack {
                Image("colorPicker")
                    .resizable()
                    .scaledToFill()
                    .frame(width: dimension, height: dimension)
                    .clipShape(Circle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let point = value.location
                                let dx = point.x - center.x
                                let dy = point.y - center.y
                                let distance = sqrt(dx*dx + dy*dy)

                                guard distance <= radius else { return }

                                let angle = atan2(dy, dx)
                                let newHue = (angle < 0 ? angle + 2 * .pi : angle) / (2 * .pi)
                                let newSaturation = distance / radius

                                hue = newHue
                                saturation = 1
                                selectedColor = Color(hue: hue, saturation: saturation, brightness: brightness)
                                indicatorPosition = CGPoint(x: center.x + dx, y: center.y + dy)
                            }
                    )

                Circle()
                    .fill(selectedColor)
                    .frame(width: 20, height: 20)
                    .position(indicatorPosition)
                    .shadow(radius: 3)
            }
            .onAppear {
                let dx = cos(0) * radius
                let dy = sin(0) * radius
                indicatorPosition = CGPoint(x: center.x + dx, y: center.y + dy)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    func toHex() -> String {
        guard let components = cgColor?.components else { return "#000000" }
        let r = components[0]
        let g = components[1]
        let b = components[2]

        let hex = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))

        return hex
    }
}

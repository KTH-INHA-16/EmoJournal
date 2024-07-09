//
//  GraidentModifer.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/8/24.
//

import SwiftUI

struct AnimatableGradientModifier: AnimatableModifier {
    let fromGradientStops: [Gradient.Stop]
    let toGradientStops: [Gradient.Stop]
    var progress: CGFloat = 0.0

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        var gradientColors = [Color]()
        
        var fromColor = UIColor(fromGradientStops[0].color)
        var toColor = UIColor(toGradientStops[0].color)
        gradientColors.append(colorMixer(fromColor: fromColor, toColor: toColor, progress: progress))
    
        if let lastFromColor = fromGradientStops.last?.color, let lastToColor = toGradientStops.last?.color {
            fromColor = UIColor(lastFromColor)
            toColor = UIColor(lastToColor)
            gradientColors.append(colorMixer(fromColor: fromColor, toColor: toColor, progress: progress))
        }

        return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    func colorMixer(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> Color {
        guard let fromColor = fromColor.cgColor.components else { return Color(fromColor) }
        guard let toColor = toColor.cgColor.components else { return Color(toColor) }

        let red = fromColor[0] + (toColor[0] - fromColor[0]) * progress
        let green = fromColor[1] + (toColor[1] - fromColor[1]) * progress
        let blue = fromColor[2] + (toColor[2] - fromColor[2]) * progress

        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

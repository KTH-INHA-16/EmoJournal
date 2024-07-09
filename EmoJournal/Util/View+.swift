//
//  View+.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/8/24.
//

import SwiftUI

extension View {
    func animatableGradient(fromGradientStops: [Gradient.Stop], 
                            toGradientStops: [Gradient.Stop],
                            progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradientStops: fromGradientStops,
                                                 toGradientStops: toGradientStops,
                                                 progress: progress))
    }
}

//
//  Gradient+.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/5/24.
//

import SwiftUI

extension Gradient {
    static let warmFlame: [Self.Stop] = [
        Gradient.Stop(color: .warmFlame1, location: 0.0),
        Gradient.Stop(color: .warmFlame2, location: 1.0)
    ]
    
    static let amyCrisp: [Self.Stop] = [
        Gradient.Stop(color: .amyCrisp1, location: 0.0),
        Gradient.Stop(color: .amyCrisp2, location: 1.0)
    ]
    
    static let blessing: [Self.Stop] = [
        Gradient.Stop(color: .blessing1, location: 0.0),
        Gradient.Stop(color: .blessing2, location: 1.0)
    ]
    
    static let plumPlate: [Self.Stop] = [
        Gradient.Stop(color: .plumPlate1, location: 0.0),
        Gradient.Stop(color: .plumPlate2, location: 0.48),
        Gradient.Stop(color: .plumPlate3, location: 1.0)
    ]
    
    static let aquaSplash: [Self.Stop] = [
        Gradient.Stop(color: .aquaSplash1, location: 0.0),
        Gradient.Stop(color: .aquaSplash2, location: 1.0)
    ]
    
    static let saintPetersburg: [Self.Stop] = [
        Gradient.Stop(color: .saintPetersburg1, location: 0.0),
        Gradient.Stop(color: .saintPetersburg2, location: 1.0)
    ]
    
    static let viciousStance: [Self.Stop] = [
        Gradient.Stop(color: .viciousStance1, location: 0.0),
        Gradient.Stop(color: .viciousStance2, location: 1.0)
    ]
    
    static let cleanMirror: [Self.Stop] = [
        Gradient.Stop(color: .cleanMirror1.opacity(0.6), location: 0.0),
        Gradient.Stop(color: .cleanMirror2.opacity(0.6), location: 1.0)
    ]
    
    static let gradientSet: [[Self.Stop]] = [warmFlame, amyCrisp, blessing, plumPlate, aquaSplash]
}

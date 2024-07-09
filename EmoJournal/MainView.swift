//
//  MainView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/4/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("ColorIdx") private var colorIdx = 0
    
    var body: some View {
        ZStack {
            BackgroundView(idx: $colorIdx)
        }
    }
}

#Preview {
    MainView()
}

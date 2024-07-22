//
//  MainView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/4/24.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    static let store = Store(initialState: BackgroundFeature.State()) {
        BackgroundFeature()
    }
    
    var body: some View {
        ZStack {
            EmptyView()
            BackgroundView(store: MainView.store)
            ListView()
        }
    }
}

#Preview {
    MainView()
}

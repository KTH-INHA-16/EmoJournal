//
//  BackgroundView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/5/24.
//

import ComposableArchitecture
import SwiftUI

struct BackgroundView: View {
    @Perception.Bindable var store: StoreOf<BackgroundFeature>
    
    var body: some View {
        ZStack {
            LinearGradient(stops: Gradient.gradientSet[store.idx], startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        store.send(.settingButtonTapped)
                    }, label: {
                        Image("setting")
                            .frame(width:45, height: 45)
                            .background(LinearGradient(
                                stops: Gradient.saintPetersburg,
                                startPoint: .trailing,
                                endPoint: .leading))
                            .clipShape(Circle())
                    })
                    .padding(.trailing, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea(.all)
        .sheet(item: $store.scope(state: \.finishSetting, action: \.finishSetting)) { selectFeatureStore in
            SelectColorView(store: selectFeatureStore)
                .presentationDetents([.medium, .height(300)])
        }
    }
}

#Preview {
    BackgroundView(store: Store(initialState: BackgroundFeature.State()) {
        BackgroundFeature()
    })
}

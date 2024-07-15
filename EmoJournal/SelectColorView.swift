//
//  SelectColorView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/5/24.
//

import ComposableArchitecture
import SwiftUI

struct SelectColorView: View {
    let store: StoreOf<SelectFeature>
    private let names = ["Warm Flame","Amy Crisp","Blessing","Plum Plate","Aqua Splash"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Colors")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 25)
                Spacer()
            }
            .padding(.top, 20)
            
            ScrollView {
                ForEach(Array(zip(names.indices, names)), id: \.0,
                        content: { idx, name in
                    VStack {
                        HStack {
                            Text(name)
                                .font(.system(size: 15, weight: .medium))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding([.bottom, .top], 10)
                        
                            LinearGradient(stops: Gradient.gradientSet[idx], startPoint: .top, endPoint: .bottom)
                                .frame(height: 250)
                                .frame(maxWidth: .infinity)
                                .clipShape(.circle)
                                .onTapGesture {
                                    store.send(.tappedColorIdx(idx))
                                }
                        
                        Divider()
                            .overlay(.white)
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 5)
                    }
                })
            }
            .scrollIndicators(.hidden)
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    SelectColorView(
        store: Store(initialState: SelectFeature.State()) {
            SelectFeature()
    })
}

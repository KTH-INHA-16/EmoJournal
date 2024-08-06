//
//  ListView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/15/24.
//

import ComposableArchitecture
import SwiftUI

struct ListView: View {
    @Perception.Bindable var store: StoreOf<ListViewFeature>
    @State private var isPresentd = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                ForEach(store.list) { data in
                    ListDetailView(store: Store(initialState: ListDetailFeature.State(data: data)) {
                        ListDetailFeature()
                    })
                    .padding(.bottom, 30)
                }
            }
            .background(.opacity(0.0))
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .padding(.bottom, 60)
            
            VStack {
                Spacer()
                
                Button(action: {
                    store.send(.writeButtonTapped)
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .font(.title)
                    
                })
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(stops: Gradient.viciousStance,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
                .clipShape(Circle())
                
            }
            .background(.opacity(0.0))
        }
        
        .fullScreenCover(item: $store.scope(state: \.finishWriting, action: \.finishWriting), 
                         content: { WriteFeatureStore in
            WriteView(store: WriteFeatureStore)
        })
        .onAppear {
            store.send(.loadPersistenceInstances)
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
}

#Preview {
    ListView(store: Store(initialState: ListViewFeature.State()) {
        ListViewFeature()
    })
}

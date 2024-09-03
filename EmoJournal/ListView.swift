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
                    VStack {
                        if let imgData = data.imageData,
                           let image = UIImage(data: imgData) {
                            HStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            }
                            .frame(height: 140)
                            .background(.gray.opacity(0.3))
                        }
                        
                        Text(data.content)
                            .frame(maxHeight: 120)
                            .padding(.horizontal, 10)
                            .multilineTextAlignment(.leading)
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text(data.date.toyyyymmdd())
                                .frame(height: 30)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Menu(content: {
                                Button(action: {
                                    store.send(.editButtonTapped(data))
                                }, label: {
                                    Image(systemName: "pencil")
                                    Text("수정")
                                })
                                
                                Button(role: .destructive,
                                       action: {
                                    store.send(.deleteButtonTapped(data))
                                }, label: {
                                    Group {
                                        Text("삭제")
                                    }.foregroundColor(.red)
                                })
                                
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.gray)
                                    .frame(width: 30, height: 30)
                            })
                        }
                        .frame(height: 30)
                    }
                    .frame(minHeight: 180, maxHeight: 420)
                    .background(.opacity(0.0))
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(LinearGradient(stops: Gradient.cleanMirror, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    }
                    .shadow(color: .gray.opacity(0.1), radius: 1, x: 3, y: 3)
                    .padding(.horizontal, 10)
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

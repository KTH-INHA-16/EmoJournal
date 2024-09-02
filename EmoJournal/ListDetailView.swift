//
//  ListDetailView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/15/24.
//

import ComposableArchitecture
import SwiftUI

struct ListDetailView: View {
    let store: StoreOf<ListDetailFeature>
    
    var body: some View {
        VStack {
            if let data = store.data.imageData,
               let image = UIImage(data: data) {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
                .frame(height: 140)
                .background(.gray.opacity(0.3))
            }
            
            Text(store.data.content)
                .frame(maxHeight: 120)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.leading)
            
            Divider()
                .padding(.vertical, 5)
            
            HStack {
                Text(store.data.date.toyyyymmdd())
                    .frame(height: 30)
                    .padding(.leading, 10)
                
                Spacer()
                
                Menu(content: {
                    Button(action: {
                        store.send(.editButtonTapped)
                    }, label: {
                        Image(systemName: "pencil")
                        Text("수정")
                    })
                    
                    Button(role: .destructive,
                           action: {
                        store.send(.deleteButtonTapped)
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

#Preview {
    ListDetailView(store: Store(initialState: ListDetailFeature.State()) {
        ListDetailFeature()
    })
}

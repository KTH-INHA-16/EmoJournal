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
            HStack {
                Text("hello")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .padding(.top, 15)
                    .padding(.leading, 10)
                
                Spacer()
                
                Text("Lorem Ipsum")
                    .padding(.top, 15)
                    .padding(.trailing, 10)
            }
            .frame(height: 50)
            .padding(.bottom, 10)
            
            HStack {
                Image("")
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .frame(minHeight: 0, maxHeight: 140)
            }
            .frame(height: 140)
            .background(.gray.opacity(0.3))
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                .frame(maxHeight: 120)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.leading)
            
            Divider()
                .padding(.vertical, 5)
            
            HStack {
                Text("2023년 05월 14일")
                    .padding(.leading, 10)
                
                Spacer()
                
                Menu(content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "pencil")
                        Text("수정")
                    })
                    
                    Button(role: .destructive,
                           action: {
                        
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
        .frame(minHeight: 200, maxHeight: 400)
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

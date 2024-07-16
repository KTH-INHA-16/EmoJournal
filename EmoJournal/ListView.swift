//
//  ListView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/15/24.
//

import SwiftUI

struct ListView: View {
    @State private var isPresentd = false
    
    var body: some View {
        ZStack {
            ScrollView {
                ListDetailView()
                ListDetailView()
                ListDetailView()
                ListDetailView()
                ListDetailView()
                ListDetailView()
                ListDetailView()
                    
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 60)
            .background(Color.red.opacity(0.4))
            
            VStack {
                Spacer()
                
                Button(action: {
                    isPresentd = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.title)
                    
                })
                .frame(width: 50, height: 50)
                .foregroundStyle(.gray.opacity(0.8))
                .background(
                    LinearGradient(stops: Gradient.viciousStance,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
                .clipShape(Circle())
                
            }
            .background(.opacity(0.0))
        }
        .fullScreenCover(isPresented: $isPresentd, content: {
            WriteView(isPresented: $isPresentd)
        })
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
}

#Preview {
    ListView()
}

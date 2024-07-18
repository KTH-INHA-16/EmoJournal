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
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                ListDetailView()
                    .padding(.bottom, 30)
                    
            }
            .background(.opacity(0.0))
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .padding(.bottom, 60)
            
            VStack {
                Spacer()
                
                Button(action: {
                    isPresentd = true
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

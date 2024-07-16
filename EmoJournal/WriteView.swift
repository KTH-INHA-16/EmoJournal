//
//  WriteView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/16/24.
//

import SwiftUI

struct WriteView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button(action: {
                                isPresented = false
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .frame(width: 15)
                                Text("닫기")
                                    .padding(.leading, -5)
                            })
                            .foregroundColor(.white)
                        })
                    }
                    .navigationTitle("오늘의 일기")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(stops: Gradient.viciousStance,
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
        }
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}

#Preview {
    WriteView(isPresented: .constant(false))
}

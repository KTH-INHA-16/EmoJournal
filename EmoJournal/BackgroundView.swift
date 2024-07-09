//
//  BackgroundView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/5/24.
//

import SwiftUI

struct BackgroundView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isPresented: Bool = false
    @State private var newIdx: Int = 0
    @Binding var idx: Int
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .ignoresSafeArea()
                .animatableGradient(fromGradientStops: Gradient.gradientSet[idx], 
                                    toGradientStops: Gradient.gradientSet[newIdx],
                                    progress: progress)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isPresented = true
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
        .sheet(isPresented: $isPresented, content: {
            SelectColorView(isPresented: $isPresented,
                            previousIdx: $idx, newIdx: $newIdx,
                            progress: $progress)
                .presentationDetents([.medium, .height(300)])
        })
    }
}

#Preview {
    BackgroundView(idx: .constant(0))
}

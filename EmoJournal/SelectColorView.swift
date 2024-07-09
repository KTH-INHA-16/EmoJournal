//
//  SelectColorView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/5/24.
//

import SwiftUI

struct SelectColorView: View {
    @AppStorage("ColorIdx") private var colorIdx = 0
    @Binding var isPresented: Bool
    @Binding var previousIdx: Int
    @Binding var newIdx: Int
    @Binding var progress: CGFloat
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
                                progress = 0.0
                                previousIdx = colorIdx
                                colorIdx = idx
                                newIdx = idx
                                isPresented = false
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
    SelectColorView(isPresented: .constant(true),
                    previousIdx: .constant(0), newIdx: .constant(0),
                    progress: .constant(0.0))
}

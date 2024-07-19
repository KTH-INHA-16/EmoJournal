//
//  WriteView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/16/24.
//

import SwiftUI
import PhotosUI

struct WriteView: View {
    @Binding var isPresented: Bool
    @State private var avatarItem: PhotosPickerItem?
    @State private var imageData: Data? = nil
    @State private var isAnimate = false
    @State private var text = """
    What is Lorem Ipsum?
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum..\n\n\n\n\n\n\n\n\n\n\n\na
    """
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let imageData = self.imageData, let image = UIImage(data: imageData) {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .animation(.linear(duration: 1), value: isAnimate)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 140)
                            
                                
                            
                            Button(action: {
                                self.imageData = nil
                                self.avatarItem = nil
                                self.isAnimate = true
                            }, label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(Color(.white))
                            })
                            .padding([.trailing, .top], 5)
                        }
                    }

                    ZStack(alignment: .topLeading) {
                        if text.isEmpty {
                            Text("내용을 입력하세요.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $text)
                            .scrollIndicators(.hidden)
                            .scrollContentBackground(.hidden)
                            .foregroundStyle(.white)
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
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(
                    LinearGradient(stops: Gradient.viciousStance,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
                
                VStack {
                    Spacer()
                    HStack {
                        GeometryReader { geo in
                            
                            PhotosPicker(selection: $avatarItem, 
                                         matching: .any(of: [.images, .not(.screenshots)]),
                                         label: {
                                Image(systemName: "photo")
                                    .foregroundStyle(.white)
                            })
                            .task(id: avatarItem, {
                                if let loaded = try? await avatarItem?.loadTransferable(type: Data.self) {
                                    withAnimation {
                                        self.imageData = loaded
                                        isAnimate = true
                                    }
                                }
                            })
                            .frame(width: geo.size.width / 2, height: 50)
                            .background(Color.darkBackground.opacity(0.7))
                            .offset(x: 0, y: geo.size.height + geo.safeAreaInsets.bottom - 50)
                            
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "mic")
                                    .foregroundStyle(.white)
                            })
                            .frame(width: geo.size.width / 2, height: 50)
                            .background(Color.darkBackground.opacity(0.7))
                            .offset(x: geo.size.width / 2, y: geo.size.height + geo.safeAreaInsets.bottom - 50)
                        }
                    }
                }
            }
        }
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}

#Preview {
    WriteView(isPresented: .constant(false))
}

//
//  WriteView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/16/24.
//

import ComposableArchitecture
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import PhotosUI

struct WriteView: View {
    @Perception.Bindable var store: StoreOf<WriteFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let image = store.image?.image {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .animation(.linear(duration: 1), value: store.isAnimate)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 140)
                            
                                
                            
                            Button(action: {
                                store.send(.photoCancelButtonTapped)
                            }, label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(Color(.white))
                            })
                            .padding([.trailing, .top], 5)
                        }
                    }

                    ZStack(alignment: .topLeading) {
                        if store.text.isEmpty {
                            Text("내용을 입력하세요.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $store.text.sending(\.textChanged))
                            .introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17, .v18)) { textView in
                                
                                if let range = textView.selectedTextRange {
                                    let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: range.start)
                                    store.send(.cursorChange(cursorPosition))
                                }
                            }
                            .scrollIndicators(.hidden)
                            .scrollContentBackground(.hidden)
                            .foregroundStyle(.white)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading, content: {
                                    Button(action: {
                                        store.send(.cancelButtonTapped)
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
                            
                            PhotosPicker(selection: $store.avatarItem.sending(\.photoLibraryButtonTapped), 
                                         matching: .any(of: [.images, .not(.screenshots)]),
                                         label: {
                                Image(systemName: "photo")
                                    .foregroundStyle(.white)
                            })
                            .frame(width: geo.size.width / 2, height: 50)
                            .background(Color.darkBackground.opacity(0.7))
                            .offset(x: 0, y: geo.size.height + geo.safeAreaInsets.bottom - 50)
                            
                            Button(action: {
                                store.send(.recordButtonTapped)
                            }, label: {
                                Image(systemName: store.isRecording == true ? "mic.slash" : "mic")
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
    WriteView(store: Store(initialState: WriteFeature.State()) {
        WriteFeature()
    })
}

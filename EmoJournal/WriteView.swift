//
//  WriteView.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/16/24.
//

import ComposableArchitecture
@_spi(Advanced) import SwiftUIIntrospect
import SwiftUI
import PhotosUI

struct WriteView: View {
    @Perception.Bindable var store: StoreOf<WriteFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        if let image = store.image?.image {
                            Image(uiImage: image)
                                .resizable()
                                .transition(.opacity)
                                .frame(width: UIScreen.main.bounds.width - 40, height: store.image == nil ? 0 : 140)
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            
                            
                            
                            Button(action: {
                                store.send(.photoCancelButtonTapped)
                            }, label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(Color(.white))
                            })
                            .transition(.opacity)
                            .padding([.trailing, .top], 5)
                        }
                    }
                    .animation(.linear(duration: 0.2), value: store.image)

                    ZStack(alignment: .topLeading) {
                        if store.text.isEmpty {
                            Text("내용을 입력하세요.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 12)
                                .transition(.slide)
                        }
                        
                        TextEditor(text: $store.text.sending(\.textChanged))
                            .transition(.slide)
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
                                
                                ToolbarItem(placement: .principal, content: {
                                    
                                    Text(store.writeDate.formatted(.iso8601.year().month().day()))
                                        .foregroundStyle(.white)
                                        .overlay {
                                            DatePicker(selection: $store.writeDate.sending(\.datePickerTapped),
                                                       displayedComponents: .date,
                                                       label: {})
                                                  .colorInvert()
                                                  .labelsHidden()
                                                  .colorMultiply(.clear)
                                        }
                                })
                                
                                ToolbarItem(placement: .topBarTrailing, content: {
                                    Button(action: {
                                        store.send(.saveButtonTapped)
                                    }, label: {
                                        Text("저장")
                                            .font(.system(size: 20))
                                            .bold()
                                    })
                                    .foregroundStyle(.white)
                                })
                            }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .animation(.linear(duration: 0.2), value: store.image)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
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
                                    .imageScale(.small)
                                    .frame(width: 50, height: 50)
                                
                            })
                            .frame(width: geo.size.width / 2, height: 50)
                            .background(Color.darkBackground.opacity(0.7))
                            .offset(x: 0, y: geo.size.height + geo.safeAreaInsets.bottom - 50)

                            
                            Button(action: {
                                store.send(.recordButtonTapped)
                            }, label: {
                                Image(systemName: store.isRecording == true ? "mic.slash" : "mic")
                                    .foregroundStyle(.white)
                                    .imageScale(.small)
                                    .frame(width: 50, height: 50)
                            })
                            .frame(width: geo.size.width / 2, height: 50)
                            .background(Color.darkBackground.opacity(0.7))
                            .offset(x: geo.size.width / 2, y: geo.size.height + geo.safeAreaInsets.bottom - 50)
                        }
                    }
                }
            }
            .animation(.linear(duration: 0.2), value: store.image)
        }
    }
}

#Preview {
    WriteView(store: Store(initialState: WriteFeature.State()) {
        WriteFeature()
    })
}

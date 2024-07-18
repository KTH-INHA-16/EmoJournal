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
    @State private var text = """
    What is Lorem Ipsum?
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

    Why do we use it?
    It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).


    Where does it come from?
    Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

    The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
    """
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let imageData = self.imageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .frame(height: 100)
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
                                    self.imageData = loaded
                                }
                            })
//                            .onChange(of: avatarItem) { newItem in
//                                Task {
//                                    if let loaded = try? await newItem?.loadTransferable(type: Data.self) {
////                                        self.image = loaded
//                                    } else {
//                                        print("Failed")
//                                    }
//                                }
//                            }
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

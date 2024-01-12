//
//  ContentView.swift
//  MLModel
//
//  Created by Ankit Kaushik on 25/12/23.
//

import SwiftUI
struct ContentView: View {
    @State var uiImage: UIImage?
    @State var ispresent = false
    @State var play = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var show = false
    @ObservedObject var classifier: ImageClassifier
    var body: some View {
        ZStack{
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button{
                        ispresent = true
                        sourceType = .camera
                    }label: {
                        RoundedRectangle(cornerRadius:20)
                            .frame(width:150,height:50)
                            .overlay {
                                HStack{
                                    Image(systemName:"camera.fill")
                                        .foregroundColor(.white)
                                    Text("Take Photo")
                                        .foregroundColor(.white)
                                }
                                .bold()
                                .font(.system(size:17))
                            }
                    }
                    .padding()
                    Spacer()
                    Button{
                        play = true
                        sourceType = .photoLibrary
                    }
                label: {
                    RoundedRectangle(cornerRadius:20)
                        .stroke(lineWidth:3)
                        .fill(Color.blue)
                        .frame(width:150,height:50)
                        .overlay {
                            HStack{
                                Image(systemName:"photo")
                                Text("Choose Photo")
                            }
                            .foregroundColor(.blue)
                            .bold()
                            .font(.system(size:15))
                        }
                }
                .padding()

                }
                Rectangle()
                    .fill(Color.white)
                    .frame(width:350,height:600)
                    .shadow(radius:10)
                    .overlay {
                        if uiImage != nil{
                            Image(uiImage:uiImage!)
                                .resizable()
                                .scaledToFit()
                        }
                        else{
                            VStack{
                                Text("Submit Image for Analysis")
                                    .font(.system(size:25))
                                    .bold()
                                Text("Snap a Photo or Share an existing Image")
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                    }
                Spacer()
                HStack{
                    Button(action: {
                        if uiImage != nil {
                            guard CIImage(image: uiImage!) != nil else {
                                print("cannot convert uiimage to ciimage")
                                return
                            }
                            classifier.detect(uiImage:uiImage!)
                        }
                        show.toggle()
                    }) {
                        RoundedRectangle(cornerRadius:20)
                            .fill(Color.black.gradient.opacity(0.7))
                            .frame(width:230,height:50)
                            .overlay{
                                HStack(spacing:20){
                                    Text("Analyse")
                                        .foregroundColor(Color.white)
                                        .bold()
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                }
                                .shadow(radius:4)
                                .font(.title)
                            }
                    }
            }
            }
            .fullScreenCover(isPresented:$ispresent){
                ImagePicker(uiImage: $uiImage, isPresenting:$ispresent, sourceType: $sourceType)
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented:$play) {
                ImagePicker(uiImage:$uiImage, isPresenting:$play, sourceType:$sourceType)
            }
            .sheet(isPresented:$show){
                    VStack{
                        if let imageClass = classifier.imageClass {
                            VStack{
                                Text("Image categories:")
                                Text(imageClass)
                                    .foregroundColor(.purple)
                            }
                            .bold()
                            .font(.system(size:25))
                        } else {
                            HStack{
                                Text("Image categories:")
                                    .bold()
                                    .font(.system(size:30))
                                    .font(.caption)
                            }
                        }
                    }
                    .presentationDetents([.height(160)])
                }
        }
    }
}
#Preview {
    ContentView(classifier:ImageClassifier())
}

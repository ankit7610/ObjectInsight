//
//  Opening.swift
//  MLModel
//
//  Created by Ankit Kaushik on 27/12/23.
//

import SwiftUI

struct Opening: View {
    @State private var progress: CGFloat = 0.5
    @State var value = Timer.publish(every:1, on:.main, in:.common).autoconnect()
    @State var change = false
    @State var val = 0.00
    @State var show = false
    @State var main = false
    var body: some View {
            ZStack{
                LinearGradient(colors:[.mint.opacity(0.6),.black,.black,.indigo.opacity(0.6)], startPoint:.top, endPoint:.bottom)
                    .ignoresSafeArea()
                VStack(spacing:80){
                    VStack{
                        Text("Scan with Ease, Organize with Precision!")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                    }
                    ZStack{
                        Circle()
                            .stroke(lineWidth: 10.0)
                            .opacity(0.3)
                            .foregroundColor(Color.gray)
                        Circle()
                            .trim(from: 0.0, to:val)
                            .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(show ? Color.green:Color.pink)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeInOut(duration: 1.0))
                        Text("Scanning...")
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(20)
                        Button{
                            main.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius:20)
                                .fill(change ? Color.green:Color.green.opacity(0.6))
                                .shadow(radius:5)
                                .frame(width:150,height:50)
                                .overlay {
                                    HStack(spacing:20){
                                        Text("Let's Go!")
                                            .bold()
                                        Image(systemName:"arrow.right.circle")
                                    }
                                    .font(.system(size:20))
                                    .foregroundColor(Color.white)
                                }
                        }
                }
                }
            .fullScreenCover(isPresented:$main, content: {
                ContentView(classifier:ImageClassifier())
            })
                .onReceive(value, perform: { t in
                    withAnimation{
                        if(val<=1){
                            val = val+0.5
                        }
                        else{
                            val = 0
                            show.toggle()
                        }
                    }
                    withAnimation(.easeInOut(duration:2)){
                        change.toggle()
                    }
                })
            }
}

#Preview {
    Opening()
}

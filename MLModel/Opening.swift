//
//  Opening.swift
//  MLModel
//
//  Created by Ankit Kaushik on 27/12/23.
//
import SwiftUI

struct Opening: View {
    @State private var progress: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var isAnimating = false
    @State private var showMainView = false
    @State private var scanningComplete = false
    @State private var pulseAnimation = false
    @State private var rotationAngle = 0.0
    @State private var showParticles = false
    
    private let darkThemeColors = [
        Color(hex: "1A1A1A"),
        Color(hex: "2D2D2D"),
        Color(hex: "0D0D0D")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Enhanced animated background
                RadialGradient(
                    gradient: Gradient(colors: darkThemeColors),
                    center: .center,
                    startRadius: 0,
                    endRadius: geometry.size.width
                )
                .ignoresSafeArea()
                .overlay(
                    ZStack {
                        ForEach(0..<20) { index in
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 4, height: 4)
                                .offset(
                                    x: CGFloat.random(in: -geometry.size.width/2...geometry.size.width/2),
                                    y: CGFloat.random(in: -geometry.size.height/2...geometry.size.height/2)
                                )
                                .opacity(showParticles ? 1 : 0)
                                .animation(
                                    Animation.easeInOut(duration: Double.random(in: 1...3))
                                        .repeatForever(autoreverses: true)
                                        .delay(Double.random(in: 0...2)),
                                    value: showParticles
                                )
                        }
                    }
                )
                
                VStack(spacing: 50) {
                    // Enhanced title section
                    VStack(spacing: 20) {
                        Text("AI Vision Pro")
                            .font(.system(size: 45, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .gray],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .purple.opacity(0.3), radius: 10)
                        
                        Text("Scan with Ease, Organize with Precision!")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Enhanced scanning animation
                    ZStack {
                        // Outer glow
                        Circle()
                            .stroke(Color.purple.opacity(0.2), lineWidth: 20)
                            .frame(width: 250, height: 250)
                            .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                            .opacity(pulseAnimation ? 0.5 : 1.0)
                        
                        // Rotating outer ring
                        Circle()
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.clear, .purple, .blue, .clear]),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(rotationAngle))
                        
                        // Progress ring
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                        
                        // Inner circle with dynamic content
                        Circle()
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 180, height: 180)
                            .overlay(
                                ZStack {
                                    // Scanner effect
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.clear, .purple.opacity(0.2), .clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: 180)
                                        .offset(y: isAnimating ? 90 : -90)
                                    
                                    Image(systemName: scanningComplete ? "checkmark.circle.fill" : "camera.viewfinder")
                                        .font(.system(size: 60))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.purple, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .symbolEffect(.bounce.byLayer, options: .repeating, value: isAnimating)
                                }
                            )
                        
                        // Status text with dynamic effects
                        VStack {
                            Spacer()
                            Text(scanningComplete ? "Ready!" : "Scanning...")
                                .font(.title2.bold())
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .gray],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .padding(.top, 280)
                        }
                    }
                    
                    // Enhanced action button
                    Button {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showMainView = true
                        }
                    } label: {
                        HStack(spacing: 15) {
                            Text("Start Scanning")
                                .font(.title3.bold())
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                                .symbolEffect(.bounce, options: .repeating, value: scanningComplete)
                        }
                        .foregroundStyle(.white)
                        .frame(width: 220, height: 60)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                // Button glow effect
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                                    .blur(radius: 1)
                            }
                        )
                        .shadow(color: .purple.opacity(0.5), radius: 20, x: 0, y: 10)
                        .scaleEffect(scanningComplete ? 1 : 0.95)
                    }
                    .disabled(!scanningComplete)
                }
                .padding()
            }
        }
        .onAppear {
            startAnimations()
        }
        .fullScreenCover(isPresented: $showMainView) {
            ContentView(classifier: ImageClassifier())
        }
    }
    
    private func startAnimations() {
        // Start scanning animation
        withAnimation(.linear(duration: 3)) {
            progress = 1.0
        }
        
        // Start background animations
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        // Start scanner effect
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        // Enable particle effect
        withAnimation {
            showParticles = true
        }
        
        // Complete scanning after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                scanningComplete = true
            }
        }
    }
}
#Preview {
    Opening()
}

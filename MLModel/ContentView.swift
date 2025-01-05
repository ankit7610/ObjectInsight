//
//  ContentView.swift
//  MLModel
//
//  Created by Ankit Kaushik on 25/12/23.
//
import SwiftUI

struct ContentView: View {
    @State private var uiImage: UIImage?
    @State private var isCameraPresented = false
    @State private var isLibraryPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showAnalysis = false
    @State private var isImageAnimating = false
    @State private var activeTab = 0
    @State private var isLoading = false
    @State private var analysisProgress: CGFloat = 0
    @ObservedObject var classifier: ImageClassifier
    
    private let darkThemeColors = [
        Color(hex: "0A0A0A"),
        Color(hex: "1A1A1A"),
        Color(hex: "0D0D0D")
    ]
    
    var body: some View {
        ZStack {
            // Premium Background
            RadialGradient(
                gradient: Gradient(colors: darkThemeColors),
                center: .center,
                startRadius: 0,
                endRadius: UIScreen.main.bounds.width
            )
            .ignoresSafeArea()
            .overlay(
                GeometryReader { geometry in
                    ForEach(0..<30) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 2...4))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.linear(duration: Double.random(in: 5...10))
                                    .repeatForever(),
                                value: isImageAnimating
                            )
                    }
                }
            )
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("AI Vision Pro")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .gray],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Scan & Analyze")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // Settings Button
                        Button {
                            // Settings action
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color(hex: "2D2D2D"))
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        PremiumActionButton(
                            icon: "camera.aperture",
                            text: "Camera",
                            isActive: activeTab == 0
                        ) {
                            withAnimation {
                                activeTab = 0
                                sourceType = .camera
                                isCameraPresented = true
                            }
                        }
                        
                        PremiumActionButton(
                            icon: "photo.stack",
                            text: "Gallery",
                            isActive: activeTab == 1
                        ) {
                            withAnimation {
                                activeTab = 1
                                sourceType = .photoLibrary
                                isLibraryPresented = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Image Display Area
                    ZStack {
                        // Background Card
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(hex: "1A1A1A"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.5), .blue.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 20)
                        
                        if let image = uiImage {
                            // Image with Effects
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(25)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                        .padding()
                                )
                                .scaleEffect(isImageAnimating ? 1 : 0.9)
                                .opacity(isImageAnimating ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isImageAnimating)
                                .onAppear { isImageAnimating = true }
                        } else {
                            // Placeholder Content
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.2), .blue.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                    
                                    Image(systemName: "camera.viewfinder")
                                        .font(.system(size: 40))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.purple, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                
                                Text("Ready to Analyze")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                Text("Take a photo or select from gallery")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .padding()
                    
                    // Analysis Button
                    Button {
                        if let image = uiImage {
                            withAnimation {
                                isLoading = true
                                analysisProgress = 0
                            }
                            
                            // Simulate progress
                            Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                                withAnimation {
                                    if analysisProgress < 1 {
                                        analysisProgress += 0.05
                                    } else {
                                        timer.invalidate()
                                        classifier.detect(uiImage: image)
                                        isLoading = false
                                        showAnalysis = true
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                HStack(spacing: 15) {
                                    Text("Analyze Image")
                                        .font(.title3.bold())
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 220, height: 60)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            colors: uiImage != nil ? [.purple, .blue] : [.gray.opacity(0.3), .gray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                if isLoading {
                                    RoundedRectangle(cornerRadius: 30)
                                        .trim(from: 0, to: analysisProgress)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                        .animation(.easeInOut, value: analysisProgress)
                                }
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: uiImage != nil ? .purple.opacity(0.5) : .clear, radius: 15)
                    }
                    .disabled(uiImage == nil || isLoading)
                }
                .padding(.vertical)
            }
        }
        .fullScreenCover(isPresented: $isCameraPresented) {
            ImagePicker(uiImage: $uiImage, isPresenting: $isCameraPresented, sourceType: $sourceType)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isLibraryPresented) {
            ImagePicker(uiImage: $uiImage, isPresenting: $isLibraryPresented, sourceType: $sourceType)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showAnalysis) {
            PremiumAnalysisView(classifier: classifier)
        }
    }
}

struct PremiumActionButton: View {
    let icon: String
    let text: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(text)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(isActive ? .white : .gray)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "1A1A1A"))
                    
                    if isActive {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: isActive ? [.purple, .blue] : [.gray.opacity(0.3), .gray.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: isActive ? .purple.opacity(0.3) : .clear, radius: 10)
        }
    }
}

struct PremiumAnalysisView: View {
    @ObservedObject var classifier: ImageClassifier
    @Environment(\.dismiss) private var dismiss
    @State private var showDetails = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0A")
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Pull indicator
                RoundedRectangle(cornerRadius: 3)
                    .fill(.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top)
                
                // Title
                Text("Analysis Results")
                    .font(.title2.bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .gray],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                if let imageClass = classifier.imageClass {
                    // Results Card
                    VStack(spacing: 15) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.green, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text(imageClass)
                            .font(.title3.bold())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(hex: "1A1A1A"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 15)
                    .onAppear {
                        withAnimation(.spring().delay(0.3)) {
                            showDetails = true
                        }
                    }
                } else {
                    // Loading State
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.purple)
                        Text("Analyzing...")
                            .foregroundColor(.gray)
                    }
                }
                
                // Confidence Level Indicator (if needed)
                if showDetails {
                    HStack {
                        Text("Confidence Level")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("98%")
                            .foregroundColor(.green)
                            .bold()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "1A1A1A"))
                                                )
                                            }
                                            
                                            // Action Buttons
                                            if showDetails {
                                                HStack(spacing: 15) {
                                                    Button {
                                                        dismiss()
                                                    } label: {
                                                        Text("Done")
                                                            .font(.title3.bold())
                                                            .foregroundColor(.white)
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 50)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 25)
                                                                    .fill(Color(hex: "2D2D2D"))
                                                            )
                                                    }
                                                    
                                                    Button {
                                                        // Share action
                                                    } label: {
                                                        Image(systemName: "square.and.arrow.up")
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                            .frame(width: 50, height: 50)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 25)
                                                                    .fill(
                                                                        LinearGradient(
                                                                            colors: [.purple, .blue],
                                                                            startPoint: .leading,
                                                                            endPoint: .trailing
                                                                        )
                                                                    )
                                                            )
                                                    }
                                                }
                                                .opacity(showDetails ? 1 : 0)
                                                .animation(.easeInOut(duration: 0.3), value: showDetails)
                                            }
                                        }
                                        .padding()
                                    }
                                    .presentationDetents([.height(400)])
                                    .presentationBackground(.clear)
                                }
                            }

                            // Helper extension for hex colors (unchanged)
                            extension Color {
                                init(hex: String) {
                                    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                                    var int: UInt64 = 0
                                    Scanner(string: hex).scanHexInt64(&int)
                                    let a, r, g, b: UInt64
                                    switch hex.count {
                                    case 3:
                                        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
                                    case 6:
                                        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
                                    case 8:
                                        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
                                    default:
                                        (a, r, g, b) = (255, 0, 0, 0)
                                    }
                                    self.init(
                                        .sRGB,
                                        red: Double(r) / 255,
                                        green: Double(g) / 255,
                                        blue: Double(b) / 255,
                                        opacity: Double(a) / 255
                                    )
                                }
                            }

                            #Preview {
                                ContentView(classifier: ImageClassifier())
                            }


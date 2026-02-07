//
//  ContentView.swift
//  CreateMLBootcamp
//
//  Created by BSTAR on 06/02/2026.
//

import SwiftUI
import CoreML

struct ProbabilityListView: View {
    
    let probs: [Dictionary<String, Double>.Element]
    
    var body: some View {
        List(probs, id: \.key) { (key, value) in
            HStack {
                Text(key)
                Text("\(value.toPercentage())%")
            }
        }
    }
}

struct ContentView: View {
    
    let images = ["1", "2", "3", "4"]
    @State private var currentIndex = 0
    @Namespace var namespace
    @State private var probs: [String: Double] = [:]
    
    var sortedProbs: [Dictionary<String, Double>.Element] {
        let arrayProbs = Array(probs)
        return arrayProbs.sorted(by: { $0.value > $1.value } )
    }
    
    let model = try? MobileNetV2(configuration: MLModelConfiguration())
    
    var body: some View {
        
        VStack {
            Image(images[currentIndex])
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .matchedGeometryEffect(id: images[currentIndex].description, in: namespace)
                .animation(.easeInOut, value: currentIndex)
        }
        .padding()
        
        HStack(spacing: 20) {
            
            Button {
                currentIndex -= 1
            } label: {
                Text("Previous")
            }
            .buttonStyle(.bordered)
            .disabled(currentIndex == 0)
            
            Button {
                currentIndex += 1
            } label: {
                Text("Next")
            }
            .buttonStyle(.bordered)
            .disabled(currentIndex == images.count - 1)
            
        }
        .padding(.bottom, 20)
        
        Button {
            onPredict()
        } label: {
            Text("Predict")
                .font(.headline)
                .frame(height: 35)
        }
        .buttonStyle(.borderedProminent)
        .glassEffect()
        .buttonSizing(.flexible)
        .padding(.horizontal, 20)
        
        ProbabilityListView(probs: sortedProbs)

        
    }
    
    func onPredict() {
        
        guard let uiImage = UIImage(named: images[currentIndex]) else { return }
        
        // resize the image
        let resizedImage = uiImage.resizeTo(CGSize(width: 224, height: 224))
        guard let buffer = resizedImage.toCVPixelBuffer() else { return }
        
        do {
            let prediction = try model?.prediction(image: buffer)
            if let classLabelProbs = prediction?.classLabelProbs {
                probs = classLabelProbs
            }
            print(prediction?.classLabel ?? "neno")
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

#Preview {
    ContentView()
}

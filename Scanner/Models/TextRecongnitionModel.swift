//
//  TextRecongnition.swift
//  Scanner
//
//  Created by Александр Устич on 17.03.2023.
//

import Foundation
import UIKit
import Vision

class TextRecongnitionModel {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func recongniseText() {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        try? handler.perform([request])
        
        // Get the recognized text from the request results
        if let results = request.results {
            let recognizedText = results.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            print("Recognized text:\n\(recognizedText)")
        }
    }
}

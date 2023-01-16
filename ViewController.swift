//
//  ViewController.swift
//  Recognize
//
//  Created by Wasitul Hoque on 14/1/23.
//

import Vision
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let pickImage = UIImagePickerController()
    private let labels: UILabel = {
        let labels = UILabel()
        labels.numberOfLines = 0
        labels.textAlignment = .center
        labels.backgroundColor = .green
        labels.font = .systemFont(ofSize: 20)
        return labels
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(labels)
        view.addSubview(imageView)
        pickImage.delegate = self
        pickImage.allowsEditing = false
        
        recognizeText(image: imageView.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20, y: 80, width: 300 , height: 100
        )
        labels.frame = CGRect(x: 20, y: view.frame.size.width + view.safeAreaInsets.top,
                              width: view.frame.size.width - 40, height: 200)
    }
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    let request = VNRecognizeTextRequest { [weak self] request , error in
        guard let observations = request.results as? [VNRecognizedTextObservation],
              error == nil else {
                  return
              }
        
        let text = observations.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: " - ")
        
        DispatchQueue.main.async {
            self?.labels.text = text
        }
    }
    
    do {
        try handler.perform([request])
    } catch {
        //
    }
    }
}


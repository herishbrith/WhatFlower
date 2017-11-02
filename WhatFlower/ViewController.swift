//
//  ViewController.swift
//  WhatFlower
//
//  Created by Apple on 28/09/17.
//  Copyright © 2017 Harsh Bhardwaj. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        imagePicker.dismiss(animated: true, completion: nil)

        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            SVProgressHUD.show()
            
            var modifiedImage: UIImage?
            
            if let imageSize = UIImagePNGRepresentation(userPickedImage)?.count {
                print("Original size of image in Bytes: ", imageSize)
            }
            
            if let resizedByPercentage = userPickedImage.resized(withPercentage: 0.25) {
                if let imageSize = UIImagePNGRepresentation(resizedByPercentage)?.count {
                    print("Size of image after resizedByPercentage: ", imageSize)
                }
//                modifiedImage = resizedByPercentage
            }
            
            if let resizedByWidth = userPickedImage.resized(toWidth: 100) {
                if let imageSize = UIImagePNGRepresentation(resizedByWidth)?.count {
                    print("Size of image after resizedByWidth: ", imageSize)
                }
                modifiedImage = resizedByWidth
            }
            
            if let compressed = userPickedImage.compressTo(0.5) {
                if let imageSize = UIImagePNGRepresentation(compressed)?.count {
                    print("Size of image after compression: ", imageSize)
                }
//                modifiedImage = compressed
            }
            
            if let image = modifiedImage {
                self.navigationItem.title = "Processing..."
                imageView.image = image
                
                guard let ciImage = CIImage(image: image) else {
                    fatalError("Could not convert UIImage to CIImage.")
                }
                detect(image: ciImage)
            }
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Could not load ML model.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let classification = request.results?.first as? VNClassificationObservation {
                SVProgressHUD.dismiss()

                self.navigationItem.title = classification.identifier.capitalized
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

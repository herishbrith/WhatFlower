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

            self.navigationItem.title = "Processing..."
            imageView.image = userPickedImage

            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage.")
            }
            detect(image: ciImage)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
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

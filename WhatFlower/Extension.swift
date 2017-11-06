//
//  Extension.swift
//  WhatFlower
//
//  Created by Apple on 02/11/17.
//  Copyright © 2017 Harsh Bhardwaj. All rights reserved.
//

import UIKit

extension UIImage {
    
    func compressTo(expectedSizeInMb: CGFloat) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress: Bool = true
        var compressingValue: CGFloat = 1.0
        var imageToCompress = self
        let originalSize = CGFloat((UIImagePNGRepresentation(self)?.count)!)

        while needCompress {
            let currentSize = CGFloat((UIImagePNGRepresentation(imageToCompress)?.count)!)
            print(currentSize)
            if currentSize < sizeInBytes || currentSize > originalSize {
                needCompress = false
                return imageToCompress
            } else {
                compressingValue -= 0.1
                if let imgData = UIImageJPEGRepresentation(imageToCompress, compressingValue) {
                    imageToCompress = UIImage(data: imgData)!
                } else {
                    return imageToCompress
                }
            }
        }
    }
    
    // Function for drawing image on a canvas with a specified width and height
    func resized(withPercentage percentage: CGFloat, imageToResize: UIImage) -> UIImage? {
        let canvasSize = CGSize(width: imageToResize.size.width * percentage, height: imageToResize.size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, imageToResize.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(expectedSizeInMb: CGFloat) -> UIImage? {
        
        // Expected size of image to be converted (in Bytes)
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        
        // Check for the while loop
        var needResize: Bool = true
        var imageToResize = self
        
        while needResize {
            
            // Determine the current size of image from image data
            if let imgData = UIImagePNGRepresentation(imageToResize) {
                let currentSize = CGFloat(imgData.count)
                print(currentSize)
                
                // Break the loop if size of image has become less than or equal to expected size
                if currentSize < sizeInBytes {
                    needResize = false
                    return imageToResize
                } else {
                    // Compress image using canvas method mentioned above
                    if let image = self.resized(withPercentage: 0.95, imageToResize: imageToResize) {
                        imageToResize = image
                    } else {
                        // If compression fails, return nil
                        needResize = false
                        return nil
                    }
                }
            } else {
                // If image data cannot be loaded, return nil
                needResize = false
                return nil
            }
        }
    }

    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

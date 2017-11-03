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
    
    func resized(withPercentage percentage: CGFloat, imageToResize: UIImage) -> UIImage? {
        let canvasSize = CGSize(width: imageToResize.size.width * percentage, height: imageToResize.size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, imageToResize.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(expectedSizeInMb: CGFloat) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needResize: Bool = true
        var imageToResize = self
        
        while needResize {
            if let imgData = UIImagePNGRepresentation(imageToResize) {
                let currentSize = CGFloat(imgData.count)
                if currentSize < sizeInBytes {
                    needResize = false
                    return imageToResize
                } else {
                    if let image = self.resized(withPercentage: 0.9, imageToResize: imageToResize) {
                        imageToResize = image
                    } else {
                        needResize = false
                        return nil
                    }
                }
            } else {
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

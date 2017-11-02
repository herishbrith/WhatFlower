//
//  Extension.swift
//  WhatFlower
//
//  Created by Apple on 02/11/17.
//  Copyright © 2017 Harsh Bhardwaj. All rights reserved.
//

import UIKit

extension UIImage {
    
    func compressTo(_ expectedSizeInMb: CGFloat) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = UIImageJPEGRepresentation(self, compressingValue) {
                if CGFloat(data.count) < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        if let data = imgData {
            if CGFloat(data.count) < sizeInBytes {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

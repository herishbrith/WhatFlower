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
                print("Size of image in Bytes: ", data.count)
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
}

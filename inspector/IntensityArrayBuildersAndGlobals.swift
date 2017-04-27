//
//  IntensityArrayBuilders.swift
//  inspector
//
//  Created by Jeremy Storer on 3/24/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import Foundation
import UIKit

var rawImage1: UIImage?
var rawImage2: UIImage?
var rawImage3: UIImage?
var rawImageViewSize: UIView?
var rawRedArray = [Int]()
var rawGreenArray = [Int]()
var rawBlueArray = [Int]()
var sampleRedArray = [Int]()
var sampleGreenArray = [Int]()
var sampleBlueArray = [Int]()
var rawIntensityArraySmoothed = [Float]()
var rawIntensityArray = [Float]()
var rawIntensityArray1 = [Int]()
var rawIntensityArray2 = [Int]()
var rawIntensityArray3 = [Int]()
var sampleImage1: UIImage?
var sampleImage2: UIImage?
var sampleImage3: UIImage?
var sampleIntensityArraySmoothed = [Float]()
var sampleIntensityArray = [Float]()
var sampleIntensityArray1 = [Int]()
var sampleIntensityArray2 = [Int]()
var sampleIntensityArray3 = [Int]()
var absorbanceArray = [Float]()
var absorbanceArraySmoothed = [Float]()
var focusValue = Float(0.0)
var minISO: Float?
var maxISO: Float?
var ISOValue = Float(222)
var exposureValue = Int32(100)
var absorbancePeak1: Int?
var absorbancePeak2: Int?
var cropStartLocation = Int(0)
var cropEndLocation = Int(0)

func makeRGBIntensityArrays(imageRef: UIImage){
    var blueFound = 0
    var redFound = 0
    rawRedArray.removeAll()
    rawGreenArray.removeAll()
    rawBlueArray.removeAll()
    
    let rgba = RGBAImage(image: imageRef)
    rgba?.process{ (pixel) -> Pixel in
        rawRedArray.append(Int(pixel.R))
        rawGreenArray.append(Int(pixel.G))
        rawBlueArray.append(Int(pixel.B))
        return pixel
    }
    
    for i in 0...rawBlueArray.count-1{
        if rawBlueArray[i] > 25 && blueFound == 0{
            cropStartLocation = i
            blueFound = 1
        }
        if(blueFound == 1){
            break
        }
    }
    
    for i in stride(from: rawRedArray.count-1, to: 0, by: -1){
        if rawRedArray[i] > 45 && redFound == 0{
            cropEndLocation = i
            redFound = 1
        }
        if(redFound == 1){
            break
        }
    }
    
    if cropStartLocation > 51 {
        cropStartLocation = cropStartLocation - 50
    } else {
        cropStartLocation = 0
    }
    
    if cropEndLocation < rawRedArray.count - 51 {
        cropEndLocation = cropEndLocation + 50
    } else {
        cropEndLocation = rawRedArray.count - 1
    }
    
}

func makeRGBIntensityArraysSample(imageRef: UIImage){

    sampleRedArray.removeAll()
    sampleGreenArray.removeAll()
    sampleBlueArray.removeAll()
    
    let rgba = RGBAImage(image: imageRef)
    rgba?.process{ (pixel) -> Pixel in
        sampleRedArray.append(Int(pixel.R))
        sampleGreenArray.append(Int(pixel.G))
        sampleBlueArray.append(Int(pixel.B))
        return pixel
    }
    
}

func cropArray(passedArray:[Float])->[Float]{
    var tArray = [Float]()
    tArray.removeAll()
    for i in 0...passedArray.count-1{
        if(i < (cropStartLocation) || i > (cropEndLocation)){
            tArray.append(0)
        }else{
                tArray.append(passedArray[i])
        }
    }
    return tArray
}

func makeIntensityArray(imageRef:UIImage) -> [Int]{
    var tempArray = [Int]()
    tempArray.removeAll()
    
    let rgba = RGBAImage(image: imageRef)
    rgba?.process{(pixel) -> Pixel in
        tempArray.append((Int(pixel.R) + Int(pixel.G) + Int(pixel.B)) / 3)
        return pixel
    }
    
    return tempArray
}

func calculateAbsorbance(){
    absorbanceArray.removeAll()
    for i in 0...rawIntensityArray.count - 1 {
        let I0 = Float(rawIntensityArraySmoothed[i])
        let I = Float(sampleIntensityArraySmoothed[i])
        var A = log10f(I0/I)
        if(A < 0){
            A = 0
        }
        absorbanceArray.append(A)
    }
}

func movingAverage(passedArray:[Float], samples: Int) -> [Float]{
    var tArray = [Float]()
    tArray.removeAll()
    for i in 0...passedArray.count-1 {
        var sum: Float
        sum = 0.0
        if i < Int(samples/2) {
            tArray.append(passedArray[i])
        } else if i > (passedArray.count - Int(samples/2) - 1){
            tArray.append(passedArray[i])
        } else{
            if samples % 2 == 0{
                for j in Int(-samples/2)...Int(samples/2) {
                    sum = sum + passedArray[i+j]
                }
            } else {
                for j in Int(-samples/2)-1...Int(samples/2) {
                    sum = sum + passedArray[i+j]
                }
            }
            tArray.append(sum / Float(samples))

        }
        
    }
    return tArray
}

func cropImage(image: UIImage) -> UIImage{
    
    let cropWidth = image.size.width / ((rawImageViewSize?.bounds.width)!/(rawImageViewSize?.bounds.height)!)
    let rect = CGRect(x:image.size.height/2 - cropWidth/2, y:0, width: cropWidth, height: (image.size.width))
    let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
    var croppedImage:UIImage = UIImage(cgImage:imageRef)
    croppedImage = croppedImage.rotated(by: Measurement(value: 90.0, unit: .degrees))!
    
    return croppedImage
}





























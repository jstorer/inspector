//
//  CameraConfigViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/25/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraConfigViewController: UIViewController {

    @IBOutlet weak var ISOLabel: UILabel!
    @IBOutlet weak var focalLabel: UILabel!
    @IBOutlet weak var exposureLabel: UILabel!
    @IBOutlet weak var ISOSlider: UISlider!
    @IBOutlet weak var FocalSlider: UISlider!
    @IBOutlet weak var ExposureSlider: UISlider!
    @IBOutlet weak var previewView: UIView!

    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var tempFocus = focusValue
    var tempISO = ISOValue
    var tempExposure = exposureValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ExposureSlider.maximumValue = 100
        self.ExposureSlider.minimumValue = 20
        self.ExposureSlider.value = self.ExposureSlider.maximumValue - Float(exposureValue) + self.ExposureSlider.minimumValue
        self.ISOSlider.maximumValue = 736
        self.ISOSlider.minimumValue = 46
        self.ISOSlider.value = ISOValue
        self.FocalSlider.maximumValue = 1
        self.FocalSlider.minimumValue = 0
        self.FocalSlider.value = focusValue
        self.ISOLabel.text = "ISO: \(roundf(self.ISOSlider.value))"
        self.exposureLabel.text = "Exposure: \(1/(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)) s"
        self.focalLabel.text = "Focus: \(self.FocalSlider.value)"
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(focusValue, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, exposureValue), iso: ISOValue, completionHandler: {(time) -> Void in})
                device?.unlockForConfiguration()
            }catch{
               // print(error)
            }
            
            stillImageOutput.isHighResolutionCaptureEnabled = true
            let input = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if(captureSession.canAddOutput(stillImageOutput)){
                    captureSession.addOutput(stillImageOutput)
                    
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.frame = self.previewView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
self.previewView.layer.insertSublayer(captureVideoLayer, at: 0)                }
            }
        }catch{
           // print(error)
        }

    }

    @IBAction func ISOSliderMoved(_ sender: Any) {
        self.ISOLabel.text = "ISO: \(roundf(self.ISOSlider.value))"
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(self.FocalSlider.value, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, Int32(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)), iso: self.ISOSlider.value, completionHandler: {(time) -> Void in})
                device?.unlockForConfiguration()
            }catch{
//                print(error)
            }
            
            stillImageOutput.isHighResolutionCaptureEnabled = true
            let input = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if(captureSession.canAddOutput(stillImageOutput)){
                    captureSession.addOutput(stillImageOutput)
                    
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.frame = self.previewView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
self.previewView.layer.insertSublayer(captureVideoLayer, at: 0)                }
            }
        }catch{
            print(error)
        }

    }
    
    
    @IBAction func focalSliderMoved(_ sender: Any) {
        self.focalLabel.text = "Focus: \(self.FocalSlider.value)"
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(self.FocalSlider.value, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, Int32(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)), iso: self.ISOSlider.value, completionHandler: {(time) -> Void in})
                device?.unlockForConfiguration()
            }catch{
//                print(error)
            }
            
            stillImageOutput.isHighResolutionCaptureEnabled = true
            let input = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if(captureSession.canAddOutput(stillImageOutput)){
                    captureSession.addOutput(stillImageOutput)
                    
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.frame = self.previewView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
self.previewView.layer.insertSublayer(captureVideoLayer, at: 0)                }
            }
        }catch{
//            print(error)
        }

        
    }
    
    @IBAction func exposureSliderMoved(_ sender: Any) {
        self.exposureLabel.text = "Exposure: \(1/(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)) s"
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(self.FocalSlider.value, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, Int32(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)), iso: self.ISOSlider.value, completionHandler: {(time) -> Void in})
                device?.unlockForConfiguration()
            }catch{
//                print(error)
            }
            
            stillImageOutput.isHighResolutionCaptureEnabled = true
            let input = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if(captureSession.canAddOutput(stillImageOutput)){
                    captureSession.addOutput(stillImageOutput)
                    
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.frame = self.previewView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
self.previewView.layer.insertSublayer(captureVideoLayer, at: 0)                }
            }
        }catch{
//            print(error)
        }

    }
    @IBAction func applyPressed(_ sender: Any) {
        ISOValue = self.ISOSlider.value
        focusValue = self.FocalSlider.value
        exposureValue = Int32(self.ExposureSlider.maximumValue - self.ExposureSlider.value + self.ExposureSlider.minimumValue)
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}













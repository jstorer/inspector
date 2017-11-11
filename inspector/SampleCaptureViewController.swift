    //
//  SampleCaptureViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/24/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import AVFoundation

class SampleCaptureViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var sampleImageImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var tempImage: UIImage!
    var imageCapturedFlag = 0

    
    @IBAction func takePhotoPressed(_ sender: Any) {
        self.nextButton.isEnabled = true
        imageCapturedFlag = 0
        var settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = true
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        
        settingsForMonitoring = AVCapturePhotoSettings(from: settingsForMonitoring)
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        
        
        settingsForMonitoring = AVCapturePhotoSettings(from: settingsForMonitoring)
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sampleImageImageView.image = sampleImage1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(sampleImage1 == nil){
            self.nextButton.isEnabled = false}
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
          

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
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(focusValue, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, exposureValue), iso: ISOValue, completionHandler: {(time) -> Void in})
                device?.videoZoomFactor = 2.0
                device?.unlockForConfiguration()
            }catch{
                print(error)
            }
        }catch{
           print(error)
        }


        // Do any additional setup after loading the view.
    }
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if(imageCapturedFlag == 1){
            sampleImage1 = cropImage(image: tempImage)
            makeRGBIntensityArraysSample(imageRef: sampleImage1!)
            self.sampleImageImageView.image = sampleImage1
        }
        if(imageCapturedFlag == 2){
            sampleImage2 = cropImage(image: tempImage)
        }
        if(imageCapturedFlag == 3){
            sampleImage3 = cropImage(image: tempImage)
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            tempImage = UIImage(data: photoData!)
            imageCapturedFlag += 1
        }
    }
    

}

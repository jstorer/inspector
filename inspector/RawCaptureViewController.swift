//
//  RawCaptureViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/24/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import AVFoundation
import Charts


class RawCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var rawImageView: UIImageView!
    @IBOutlet weak var rgbGraph: LineChartView!
    @IBOutlet weak var takePhotoButton: UIButton!
//    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var boundingBoxImage: UIImageView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var tempImage: UIImage!
    var imageCapturedFlag = 0
    
    
    @IBAction func takePhotoPressed(_ sender: Any) {
        self.nextButton.isEnabled = true
        imageCapturedFlag = 0
        rawImageViewSize = self.rawImageView
        
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
        self.rawImageView.image = rawImage1
        
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(rawImage1 == nil){
            self.nextButton.isEnabled = false}
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            
            do{
                try device?.lockForConfiguration()
                device?.setFocusModeLockedWithLensPosition(focusValue, completionHandler: {(time) -> Void in})
                device?.setExposureModeCustomWithDuration(CMTimeMake(1, exposureValue), iso: ISOValue, completionHandler: {(time) -> Void in})
                device?.videoZoomFactor = 2.0
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
                    self.previewView.layer.insertSublayer(captureVideoLayer, at: 0)
                }
            }
        }catch{
//            print(error)
        }
    }

    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if(imageCapturedFlag == 1){
         rawImage1 = cropImage(image: tempImage)
         makeRGBIntensityArrays(imageRef: rawImage1!)
        
//            var redVals: [ChartDataEntry] = [ChartDataEntry]()
//            for i in 0...rawRedArray.count-1{
//                redVals.append(ChartDataEntry(x: Double(i), y: Double(rawRedArray[i])))
//            }
//            var greenVals: [ChartDataEntry] = [ChartDataEntry]()
//            for i in 0...rawGreenArray.count-1{
//                greenVals.append(ChartDataEntry(x: Double(i), y: Double(rawGreenArray[i])))
//            }
//            var blueVals: [ChartDataEntry] = [ChartDataEntry]()
//            for i in 0...rawBlueArray.count-1{
//                blueVals.append(ChartDataEntry(x: Double(i), y: Double(rawBlueArray[i])))
//            }
//
//            let redSet: LineChartDataSet = LineChartDataSet(values: redVals, label: "red channel")
//            redSet.axisDependency = .left
//            redSet.setColor(UIColor.red)
//            redSet.lineWidth = 0.5
//            redSet.circleRadius = 0
//            redSet.fillColor = UIColor.red
//            redSet.highlightColor = UIColor.clear
//            redSet.highlightLineWidth = 1.2
//
//            let greenSet: LineChartDataSet = LineChartDataSet(values: greenVals, label: "green channel")
//            greenSet.axisDependency = .left
//            greenSet.setColor(UIColor.green)
//            greenSet.lineWidth = 0.5
//            greenSet.circleRadius = 0
//            greenSet.fillColor = UIColor.green
//            greenSet.highlightColor = UIColor.clear
//            greenSet.highlightLineWidth = 1.2
//
//            let blueSet: LineChartDataSet = LineChartDataSet(values: blueVals, label: "blue channel")
//            blueSet.axisDependency = .left
//            blueSet.setColor(UIColor.blue)
//            blueSet.lineWidth = 0.5
//            blueSet.circleRadius = 0
//            blueSet.fillColor = UIColor.blue
//            blueSet.highlightColor = UIColor.clear
//            blueSet.highlightLineWidth = 1.2
//
//            var dataSets:[LineChartDataSet] = [LineChartDataSet]()
//            dataSets.append(redSet)
//            dataSets.append(greenSet)
//            dataSets.append(blueSet)
//
//            let data: LineChartData = LineChartData(dataSets: dataSets)
//            self.rgbGraph.data = data
//            self.rgbGraph.leftAxis.drawLabelsEnabled = false
//            self.rgbGraph.rightAxis.drawLabelsEnabled = true
//            self.rgbGraph.xAxis.drawLabelsEnabled = false
//            self.rgbGraph.chartDescription?.text = "rgb values vs pixel"
//            self.rgbGraph.pinchZoomEnabled = false
//            self.rgbGraph.doubleTapToZoomEnabled = false
//
//           previewView.isHidden = true
//            rgbGraph.isHidden = false
            
            
        self.rawImageView.image = rawImage1
        }
        if(imageCapturedFlag == 2){
            rawImage2 = cropImage(image: tempImage)
        }
        if(imageCapturedFlag == 3){
            rawImage3 = cropImage(image: tempImage)
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

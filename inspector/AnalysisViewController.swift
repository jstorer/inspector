//
//  AnalysisViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/25/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import Charts
import MessageUI


class AnalysisViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var absorbanceGraph: LineChartView!

    
    @IBAction func calculatePressed(_ sender: Any) {
        var max1 = Float(0)
        var max2 = Float(0)
        for i in 50...400 {
            if absorbanceArraySmoothed[i] > max1{
                max1 = absorbanceArraySmoothed[i]
                absorbancePeak1 = i
            }
        }
        
        for i in 775...1100{
            if absorbanceArraySmoothed[i] > max2{
                max2 = absorbanceArraySmoothed[i]
                absorbancePeak2 = i
            }
        }
        
        let ratio = max2 / max1
        let nitratePPM = roundf((ratio - 0.086) / 0.0527)
         
        self.calculationLabel.isHidden = false
        if(nitratePPM < 2){
            self.calculationLabel.text = "nitrate concentration of less than 2 ppm"
        } else{
            self.calculationLabel.text = "nitrate concentration between \(Float(nitratePPM)-1) and \(Float(nitratePPM)+1) ppm"
        }
    }
    @IBAction func exportDataPressed(_ sender: Any) {
        let fileName = "inSPECtor.csv"
//        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Pixel, Raw1 R, Raw1 G, Raw1 B, Raw1 I, Raw2 I, Raw3 I, Avg Raw I, Samp1 R, Samp1 G, Samp1 B, Samp1 I, Samp2 I, Samp3 I, Samp Avg I, Absorbance, Smoothed Absorbance\n"
        let count = rawIntensityArray.count
        
        for i in 0...count-1 {
            let newLine = "\(String(i)),\(String(rawRedArray[i])),\(String(rawGreenArray[i])),\(String(rawBlueArray[i])),\(String(rawIntensityArray1[i])),\(String(rawIntensityArray2[i])),\(String(rawIntensityArray3[i])),\(String(rawIntensityArray[i])),\(String(sampleRedArray[i])),\(String(sampleGreenArray[i])),\(String(sampleBlueArray[i])),\(String(sampleIntensityArray1[i])),\(String(sampleIntensityArray2[i])),\(String(sampleIntensityArray3[i])),\(String(sampleIntensityArray[i])),\(String(absorbanceArray[i])),\(String(absorbanceArraySmoothed[i]))\n"
            csvText.append(newLine)
        }
        
        let data = csvText.data(using: String.Encoding.utf8,allowLossyConversion: false)
        if let content = data{
            print("NSData: \(content)")
        }
        
        let rawImageMail = UIImagePNGRepresentation(rawImage1!)
        let sampleImageMail = UIImagePNGRepresentation(sampleImage1!)
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setSubject("CSV and Images from InSPECtor")
        emailController.setMessageBody("", isHTML: false)
        
        // Attaching the .CSV file to the email.
        emailController.addAttachmentData(data!, mimeType: "text/csv", fileName: fileName)
        emailController.addAttachmentData(rawImageMail!, mimeType: "image/png", fileName: "rawImage")
        emailController.addAttachmentData(sampleImageMail!, mimeType: "image/png", fileName: "sampleImage")
        
        if MFMailComposeViewController.canSendMail(){
            self.present(emailController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calculationLabel.isHidden = true
        var dataSets:[LineChartDataSet] = [LineChartDataSet]()
        var yValsAbsorbance: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...absorbanceArray.count-1{
            yValsAbsorbance.append(ChartDataEntry(x: Double(i), y: Double(absorbanceArraySmoothed[i])))
        }
        let set3: LineChartDataSet = LineChartDataSet(values: yValsAbsorbance, label: "absorbance")
        set3.axisDependency = .left
        set3.setColor(UIColor.black)
        set3.lineWidth = 1.0
        set3.circleRadius = 0
        set3.fillColor = UIColor.black
        
        dataSets.removeAll()
        dataSets.append(set3)
        
        let absorbanceData: LineChartData = LineChartData(dataSets: dataSets)
        self.absorbanceGraph.data = absorbanceData
        self.absorbanceGraph.leftAxis.drawLabelsEnabled = false
        self.absorbanceGraph.rightAxis.drawLabelsEnabled = true
        self.absorbanceGraph.xAxis.drawLabelsEnabled = true
        self.absorbanceGraph.rightAxis.axisMaximum = 1.4
        self.absorbanceGraph.chartDescription?.text = "absorbance vs pixel"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

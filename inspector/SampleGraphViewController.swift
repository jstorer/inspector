//
//  SampleGraphViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/24/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import Charts

class SampleGraphViewController: UIViewController {

    @IBOutlet weak var rawImageImageView: UIImageView!
    @IBOutlet weak var sampleImageImageView: UIImageView!
    @IBOutlet weak var rawVsSampleChart: LineChartView!
    @IBOutlet weak var absorbanceChart: LineChartView!

    override func viewWillAppear(_ animated: Bool) {
        self.rawImageImageView.image = rawImage1
        self.sampleImageImageView.image = sampleImage1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sampleIntensityArray1 = makeIntensityArray(imageRef: sampleImage1!)
        sampleIntensityArray2 = makeIntensityArray(imageRef: sampleImage2!)
        sampleIntensityArray3 = makeIntensityArray(imageRef: sampleImage3!)

        
        sampleIntensityArray.removeAll()
        for i in 0...sampleIntensityArray1.count - 1 {
            sampleIntensityArray.append(Float(sampleIntensityArray1[i] + sampleIntensityArray2[i] + sampleIntensityArray3[i])/3)
        }
        
        sampleIntensityArraySmoothed = movingAverage(passedArray: sampleIntensityArray, samples: 4)
        sampleIntensityArray = cropArray(passedArray: sampleIntensityArray)
        calculateAbsorbance()
        
        absorbanceArraySmoothed = movingAverage(passedArray: absorbanceArray, samples: 20)
        
        var yValsRaw: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...rawIntensityArray.count-1{
            yValsRaw.append(ChartDataEntry(x: Double(i), y: Double(rawIntensityArray[i])))
        }
        
        var yValsSample: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...rawIntensityArray.count-1{
            yValsSample.append(ChartDataEntry(x: Double(i), y: Double(sampleIntensityArray[i])))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yValsRaw, label: "raw")
        set1.axisDependency = .left
        set1.setColor(UIColor.red)
        set1.lineWidth = 1.0
        set1.circleRadius = 0
        set1.fillColor = UIColor.red
        
        let set2: LineChartDataSet = LineChartDataSet(values: yValsSample, label: "sample")
        set2.axisDependency = .left
        set2.setColor(UIColor.blue)
        set2.lineWidth = 1.0
        set2.circleRadius = 0
        set2.fillColor = UIColor.blue
        
        var dataSets:[LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        self.rawVsSampleChart.data = data
        self.rawVsSampleChart.leftAxis.drawLabelsEnabled = false
        self.rawVsSampleChart.rightAxis.drawLabelsEnabled = true
        self.rawVsSampleChart.xAxis.drawLabelsEnabled = false
        self.rawVsSampleChart.chartDescription?.text = "raw and sample light intensity vs pixel"
        
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
        self.absorbanceChart.data = absorbanceData
        self.absorbanceChart.leftAxis.drawLabelsEnabled = false
        self.absorbanceChart.rightAxis.drawLabelsEnabled = true
        self.absorbanceChart.xAxis.drawLabelsEnabled = false
        self.absorbanceChart.rightAxis.axisMaximum = 1.2
        self.absorbanceChart.chartDescription?.text = "absorbance vs pixel"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

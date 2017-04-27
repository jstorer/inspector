//
//  RawGraphViewController.swift
//  inspector
//
//  Created by Jeremy Storer on 3/24/17.
//  Copyright © 2017 Jeremy Storer. All rights reserved.
//

import UIKit
import Charts

class RawGraphViewController: UIViewController {

    @IBOutlet weak var rawImageImageView: UIImageView!
    @IBOutlet weak var rawIntensityGraphView: LineChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rawImageImageView.image = rawImage1
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rawIntensityArray1 = makeIntensityArray(imageRef: rawImage1!)
        rawIntensityArray2 = makeIntensityArray(imageRef: rawImage2!)
        rawIntensityArray3 = makeIntensityArray(imageRef: rawImage3!)

        rawIntensityArray.removeAll()
        
        for i in 0...rawIntensityArray1.count - 1 {
            rawIntensityArray.append(Float(rawIntensityArray1[i] + rawIntensityArray2[i] + rawIntensityArray3[i])/3)
        }
        
        rawIntensityArray = cropArray(passedArray: rawIntensityArray)
        
        rawIntensityArraySmoothed = movingAverage(passedArray: rawIntensityArray, samples: 100)

        var yVals: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...rawIntensityArray.count-1{
             yVals.append(ChartDataEntry(x: Double(i), y: Double(rawIntensityArray[i])))
        }
        
        var yVals2: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0...rawIntensityArray.count-1{
            yVals2.append(ChartDataEntry(x: Double(i), y: Double(rawIntensityArraySmoothed[i])))
        }
        
        let set2: LineChartDataSet = LineChartDataSet(values: yVals, label: "raw intensity")
        set2.axisDependency = .left
        set2.setColor(UIColor.red)
        set2.lineWidth = 1.0
        set2.circleRadius = 0
        set2.fillColor = UIColor.red
        
        var dataSets:[LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set2)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        self.rawIntensityGraphView.data = data
        self.rawIntensityGraphView.leftAxis.drawLabelsEnabled = false
        self.rawIntensityGraphView.rightAxis.drawLabelsEnabled = true
        self.rawIntensityGraphView.xAxis.drawLabelsEnabled = false
        self.rawIntensityGraphView.chartDescription?.text = "raw light intensity vs pixel"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

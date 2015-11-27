//
//  ApplyFunctionSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 26/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit


internal class ApplyFunctionSampleViewController: BaseSampleViewController {
    
    @IBOutlet weak var percentDoneLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'Apply\' sample", storyboardID: "ApplyFunctionSampleViewController")
    }
    
    private func setCalculationValue(value: String) {
        percentDoneLabel.text = value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startProgressAnimation()
        
        asyncOnDefault {
            self.numbers = generateRandomNumbers(self.countOfNumbers)
            asyncOnMain {
                self.stopProgressAnimation()
                self.resetLabels(true)
            }
        }
    }
    
    private func setTimeElapsedValue(timer: Timer? = nil) {
        if let timer = timer {
            let seconds = timer.seconds
            timeElapsedLabel.text = "Time elapsed (sec.): \(DefaultNumberFormatter.stringFromNumber(seconds)!)"
        } else {
            timeElapsedLabel.text = "Time elapsed (sec.): 0"
        }
    }
    
    private func resetLabels(value: Bool) {
        setCalculationValue(value ? "Ready" : "Not Ready")
        setTimeElapsedValue()
    }

    private let countOfNumbers = 100_000_000
    private var numbers = [Int]()

    @IBAction func asyncGenerationTapped() {
        resetLabels(false)
        startProgressAnimation()

        let numberOfPartitions = 4
        let partitionSize = countOfNumbers / numberOfPartitions

        var timer = Timer()
        timer.start()
        
        var mins = [Int](count: numberOfPartitions, repeatedValue: 0)
        dispatch_apply(numberOfPartitions, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            partitionNumber in
            
            let copy = self.numbers
            
            var localMin = Int.max
            let rightBound = (partitionNumber + 1) * partitionSize
            for var index = partitionNumber * partitionSize; index < rightBound; ++index {
                let number = copy[index]
                localMin = localMin < number ? localMin : number
            }
            
            mins[partitionNumber] = localMin
        }
        
        var globalMin = Int.max
        for var index = 0; index < numberOfPartitions; ++index {
            let localMin = mins[index]
            globalMin = globalMin < localMin ? globalMin : localMin
        }
        
        timer.stop()
        
        stopProgressAnimation()
        setCalculationValue(String(globalMin))
        setTimeElapsedValue(timer)
    }

    @IBAction func syncGenerationTapped() {
        resetLabels(false)
        
        var realMin = Int.max

        startProgressAnimation()
        
        var timer = Timer()
        timer.start()
        
        for var index = 0; index < countOfNumbers; ++index {
            let value = numbers[index]
            realMin = realMin < value ? realMin : value
        } // 1.93

//        for index in 0..<countOfNumbers {
//            realMin = min(realMin, numbers[index])
//        } // 3
//        realMin = numbers.minElement()! // 22.83
//        realMin = numbers.reduce(Int.max, combine: min) // 28.97!!!
        
        timer.stop()
        
        stopProgressAnimation()
        
        setCalculationValue(String(realMin))
        setTimeElapsedValue(timer)
    }
    
}


//
//  ProducerConsumerSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class ProducerConsumerSampleViewController: BaseSampleViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var primes = [Int]()
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'Producer-Consumer\' sample", storyboardID: "ProducerConsumerSampleViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start PC", style: .Plain, target: self, action: Selector("toggleProducerConsumerTapped"))
    }

    internal func toggleProducerConsumerTapped() {
        if primeNumberConsumer == nil && primeNumberConsumer == nil {
            startProducerConsumerDemo()
        } else {
            stopProducerConsumerDemo()
        }
    }
    
    
    
    private var queue: PCQueue? = nil
    private var primeNumberProducer: PrimeNumberProducer? = nil
    private var primeNumberConsumer: PrimeNumberConsumer? = nil
    
    private func startProducerConsumerDemo() {
        guard queue == nil && primeNumberConsumer == nil && primeNumberConsumer == nil else { return }
       
        reset()
        navigationItem.rightBarButtonItem!.title = "Stop PC"
        
        let lock = NSCondition()
        lock.name = "ru.VKUniversity.ProducerConsumerSampleCondition"
        
        queue = PCQueue()
        primeNumberProducer = PrimeNumberProducer(queue: queue!, pause: 1, lock: lock)
        primeNumberConsumer = PrimeNumberConsumer(queue: queue!, lock: lock) { [unowned self] newPrimes in
            let (oldCount, newCount) = (self.primes.count, self.primes.count + newPrimes.count)
            self.primes += newPrimes
            asyncOnMain { [unowned self] in
                let indexPaths = (oldCount..<newCount).map { NSIndexPath(forRow: $0, inSection: 0) }
                self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                self.title = "Produced: \(self.primes.count)"
            }
        }
        primeNumberProducer!.start()
        primeNumberConsumer!.start()
    }
    
    private func stopProducerConsumerDemo() {
        guard let _ = queue, p = primeNumberProducer, c = primeNumberConsumer else { return }
        
        p.cancel()
        c.cancel()
        
        primeNumberProducer = nil
        primeNumberConsumer = nil
        queue = nil
        
        navigationItem.rightBarButtonItem!.title = "Start PC"
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            stopProducerConsumerDemo()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return primes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PCSampleCellID", forIndexPath: indexPath)
        cell.textLabel!.text = primes[indexPath.row].description
        return cell
    }
    
    private func reset() {
        primes.removeAll()
        tableView.reloadData()
    }
}

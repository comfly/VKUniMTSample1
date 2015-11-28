//
//  FileSystemSampleViewController.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 27/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import UIKit

internal class FileSystemSampleViewController: BaseSampleViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override class var sampleDescriptor: SampleDescriptor! {
        return SampleDescriptor(title: "\'File system\' sample", storyboardID: "FileSystemSampleViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Process", style: .Plain, target: self, action: Selector("processFileTapped"))
    }
    
    private var letters = [Int](count: 26, repeatedValue: 0)
    private var fileProcessor: FileProcessor? = nil
    private var processed: Int = 0
    
    internal func processFileTapped() {
        processed = 0
        letters = [Int](count: 26, repeatedValue: 0)
        self.fileProcessor?.stopReading()
        
        let fileURL = NSBundle.mainBundle().URLForResource("mobydick", withExtension: "txt")!
        let fileProcessor = FileProcessor(fileURL: fileURL)
        self.fileProcessor = fileProcessor
        if let fileSize = fileProcessor.fileSize().asOptional {
            fileProcessor.startReading({ [unowned self]
                characters, size in
                self.processed += size
                let percent = DefaultPercentFormatter.stringFromNumber(Double(self.processed) / Double(fileSize))!
                self.title = "Processed: \(percent)"
                for (index, count) in characters.enumerate() {
                    self.letters[index] += count
                }
                self.tableView.reloadData()
            }) { [unowned self] in
                if let error = $0 {
                    NSLog(error.description)
                    self.title = "Error"
                } else {
                    self.title = "Done"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if let fp = fileProcessor where parent == nil {
            fp.stopReading()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LetterStatsCellID", forIndexPath: indexPath)
        cell.textLabel!.text = String(letterFromRow(indexPath.row))
        cell.detailTextLabel!.text = letters[indexPath.row].description
        return cell
    }
    
    private func letterFromRow(row: Int) -> Character {
        return Character(UnicodeScalar(UInt8(0x41 + row)))   // 'A' + row
    }
}

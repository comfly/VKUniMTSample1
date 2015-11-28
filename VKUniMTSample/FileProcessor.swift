//
//  FileProcessor.swift
//  VKUniMTSample
//
//  Created by Dmitry Zakharov on 28/11/15.
//  Copyright © 2015 VKontakte. All rights reserved.
//

import Foundation

public class FileProcessor {
    private let fileURL: NSURL
    private let queue = dispatch_queue_create("ru.VKUniversity.FileSampleQueue", DISPATCH_QUEUE_CONCURRENT)
    
    init(fileURL: NSURL) {
        self.fileURL = fileURL
    }
    
    var file: dispatch_io_t?
    var completionBlock: (NSError? -> Void)?
    public func startReading(progressBlock: ([Int], Int) -> Void, completionBlock: NSError? -> Void) {
        self.completionBlock = completionBlock
        let complete = self.complete
        let queue = self.queue
        
        if let file = dispatch_io_create_with_path(DISPATCH_IO_STREAM, fileURL.fileSystemRepresentation, O_RDONLY, 0, queue, nil) {
            self.file = file
            return fileSize().either({error in asyncOnMain { completionBlock(error) }}) {
                fileSize in
                dispatch_io_read(file, 0, fileSize, queue) {
                    done, data, error in
                    guard error == 0 else {
                        return complete(NSError(domain: ApplicationDomain, code: Errors.FileReadError.rawValue, userInfo: nil))
                    }
                    
                    let dataSize = dispatch_data_get_size(data)
                    guard !(done && dataSize == 0) else {
                        return complete(nil)
                    }
                    
                    dispatch_data_apply(data) {
                        _, _, buffer, size in
                        var characters = [Int](count: 26, repeatedValue: 0)
                        let data = UnsafeBufferPointer<UInt8>(start: UnsafePointer(buffer), count: size)
                        for case let code? in data.map(codeFromLetterChar) {
                            characters[code] += 1
                        }
                        asyncOnMain { progressBlock(characters, size) }
                        return true
                    }
                }
            }
        } else {
            complete(NSError(domain: ApplicationDomain, code: Errors.FileReadError.rawValue, userInfo: nil))
        }
    }
    
    public func stopReading() {
        if let f = self.file {
            self.closeFile(f)
        }
    }
    
    private func complete(error: NSError?) {
        if let f = self.file {
            closeFile(f)
        }
        asyncOnMain { self.completionBlock?(error) }
    }
    
    public func fileSize() -> Result<Int> {
        do {
            var tmp: AnyObject? = nil
            try fileURL.getResourceValue(&tmp, forKey: NSURLFileSizeKey)
            if let f = tmp, fileSize = f as? NSNumber {
                return .Value(fileSize.integerValue)
            } else {
                return .Error(NSError(domain: ApplicationDomain, code: Errors.FileReadError.rawValue, userInfo: nil))
            }
        } catch {
            return .Error(NSError(domain: ApplicationDomain, code: Errors.FileReadError.rawValue, userInfo: nil))
        }
    }
    
    private func closeFile(file: dispatch_io_t) {
        dispatch_io_close(file, DISPATCH_IO_STOP)
    }
}

private func codeFromLetterChar(char: UInt8) -> Int? {
    let ichar = Int(char)
    switch ichar {
    case 0x41...0x5A: return ichar - 0x41
    case 0x61...0x7A: return ichar - 0x61
    case _: return nil
    }
}
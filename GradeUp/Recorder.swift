//
//  Recorder.swift
//  GradeUp
//
//  Created by Adrien morel on 2/14/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import AVFoundation
import Darwin

class Recorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    static let instance = Recorder()
    
    enum RecordingMode {
        case Question
        case Answer
    }
    
    static func recordingURL(recordingMode: RecordingMode,
        name: String, identifier: Int) -> NSURL {
            
            func getDocumentsDirectory() -> String {
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)
                return paths[0]
            }
            
            
            func makeName(recordingMode: RecordingMode,
                name: String, identifier: Int) -> String {
                    
                    let recordMode = recordingMode == .Question ? "question" : "answer"
                    return "\(name)\(recordMode)\(String(identifier)).m4a"
            }
            
            
            let fileManager = NSFileManager.defaultManager()
            let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentDirectory = urls[0] as NSURL
            let soundURL = documentDirectory.URLByAppendingPathComponent(makeName(recordingMode, name: name, identifier: identifier))
            return soundURL
    }

    static func stop() {
        instance.recorder.stop()
    }
    
    static func setupRecorder(recordingMode: RecordingMode,
        categoryName: String, identifier: Int) {
            
            let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]

            let outputURL = Recorder.recordingURL(recordingMode, name: categoryName, identifier: identifier)
            print(outputURL.absoluteString)
            try! instance.recorder = AVAudioRecorder(URL: outputURL, settings: settings)
            instance.recorder.prepareToRecord()
            instance.recorder.meteringEnabled = true
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                try AVAudioSession.sharedInstance().setActive(true)
                AVAudioSession.sharedInstance().requestRecordPermission({(allowed: Bool) -> Void in})
            }
            
            catch let error as NSError {
                NSLog("Error: \(error)")
            }
            
    }
    
    static func start(recordingMode: RecordingMode,
                      categoryName: String, identifier: Int)
    {
        setupRecorder(recordingMode, categoryName: categoryName, identifier: identifier)
        instance.recorder.record()
    }
    
    static func play(recordingMode: RecordingMode,
        categoryName: String, identifier: Int) {
        
        if let player = instance.player {
            player.stop()
            instance.player = nil
        }

        do {
            let outputURL = Recorder.recordingURL(recordingMode, name: categoryName, identifier: identifier)
            try instance.player = AVAudioPlayer(contentsOfURL: outputURL)
            instance.player.meteringEnabled = true

        }
        catch let error as NSError {
            NSLog("error: \(error)")
            return
        }
        
        instance.player.volume = 3
        instance.player.play()
    }
}



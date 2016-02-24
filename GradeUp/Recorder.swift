//
//  Recorder.swift
//  GradeUp
//
//  Created by Adrien morel on 2/14/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import AVFoundation
import Darwin

/*
class Recorderlol: NSObject, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    static var audioRecorder: AVAudioRecorder!
    
    static var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatMPEG4AAC),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    
    override init() {
        
        super.init()
        
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recordingSession.requestRecordPermission() { (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        print("allowed to record")
                    } else {
                        print("failed to record")
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }

    static func makeName(recordingMode: RecordingMode,
        name: String, identifier: Int) -> String {
        
        let recordMode = recordingMode == .Question ? "question" : "answer"
        return "foo.m4a"
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    static func directoryURL(recordingMode: RecordingMode,
            name: String, identifier: Int) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
                let soundURL = documentDirectory.URLByAppendingPathComponent(makeName(recordingMode, name: name, identifier: identifier))
        print(soundURL)
        return soundURL
    }
    
    static func start(recordingMode: RecordingMode,
            categoryName: String, identifier: Int) {

                Recorder.recordSettings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
                    AVSampleRateKey: NSNumber(integer: 44100),
                    AVNumberOfChannelsKey: NSNumber(integer: 2)]
                
                
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL(recordingMode, name: categoryName, identifier: identifier)!, settings: Recorder.recordSettings)
            try audioSession.setActive(true)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("ERROR !")
        }
    }
    
    static func stop() {
        
        if audioRecorder == nil || !audioRecorder.recording {
            return
        }
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("ERROR !")
        }
    }
    
    static var player: AVAudioPlayer!
    
    static func playRandomQuestion(category: Category) -> Int {
        let selectedIdx = Int(arc4random_uniform(UInt32(category.qas.count)))
        
        playRecording(.Question, name: category.name, identifier: category.qas[selectedIdx].identifier)
        
        return selectedIdx
    }
    

}
*/




























// MARK: AudioRecorderChildViewController

class Recorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    var outputURL: NSURL
    
    static let instance = Recorder()
    
    enum RecordingMode {
        case Question
        case Answer
    }

    
    static func makeName(recordingMode: RecordingMode,
        name: String, identifier: Int) -> String {
            
            let recordMode = recordingMode == .Question ? "question" : "answer"
            return "\(name)\(recordMode)\(String(identifier)).m4a"
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    static func recordingURL(recordingMode: RecordingMode,
        name: String, identifier: Int) -> NSURL {
            let fileManager = NSFileManager.defaultManager()
            let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentDirectory = urls[0] as NSURL
            let soundURL = documentDirectory.URLByAppendingPathComponent(makeName(recordingMode, name: name, identifier: identifier))
            return soundURL
    }
    
    override init() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let outputPath = documentsPath.stringByAppendingPathComponent("\(NSUUID().UUIDString).m4a")
        
        outputURL = Recorder.recordingURL(.Question, name: "foo", identifier: 42)
    
        super.init()

        let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
        try! recorder = AVAudioRecorder(URL: outputURL, settings: settings)
        recorder.delegate = self
        recorder.prepareToRecord()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            NSLog("Error: \(error)")
        }
    }
    
    static func stop() {
        instance.recorder.stop()
    }
    
    static func setupRecorder(recordingMode: RecordingMode,
        categoryName: String, identifier: Int) {
            
            if instance.recorder != nil {
                instance.recorder.stop()
                instance.recorder = nil
            }
            
            let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]

            instance.outputURL = Recorder.recordingURL(recordingMode, name: categoryName, identifier: identifier)
            print(instance.outputURL.absoluteString)
            try! instance.recorder = AVAudioRecorder(URL: instance.outputURL, settings: settings)
            instance.recorder.prepareToRecord()
            

            
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
        print(instance.recorder.record())
    }
    
    static func play(recordingMode: RecordingMode,
        categoryName: String, identifier: Int) {
        
        if let player = instance.player {
            player.stop()
            instance.player = nil
        }
            
        do {
            instance.outputURL = Recorder.recordingURL(recordingMode, name: categoryName, identifier: identifier)
            print("playin \(instance.outputURL.absoluteString)")
            try instance.player = AVAudioPlayer(contentsOfURL: instance.outputURL)
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        //instance.player?.delegate = self
        instance.player?.volume = 5
        instance.player?.play()
        
    }
    
    // MARK: Playback Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
    }    
}



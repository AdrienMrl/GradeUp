//
//  Recorder.swift
//  GradeUp
//
//  Created by Adrien morel on 2/14/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import AVFoundation


class Recorder: NSObject, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    static var audioRecorder: AVAudioRecorder!
    
    static var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    static let instance = Recorder()
    
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
    
    static func makeName(recordingMode: EditCategoryViewController.RecordingMode,
        name: String, identifier: Int) -> String {
        
        let recordMode = recordingMode == .Question ? "question" : "answer"
        return "\(recordMode)\(name)\(identifier).caf"
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    static func directoryURL(recordingMode: EditCategoryViewController.RecordingMode,
            name: String, identifier: Int) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
                let soundURL = documentDirectory.URLByAppendingPathComponent(makeName(recordingMode, name: name, identifier: identifier))
        print(soundURL)
        return soundURL
    }
    
    static func start(recordingMode: EditCategoryViewController.RecordingMode,
            categoryName: String, identifier: Int) {

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL(recordingMode, name: categoryName, identifier: identifier)!, settings: Recorder.recordSettings)
            try audioSession.setActive(true)
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
        
        print("stopped recording")
    }
    
    static var player: AVAudioPlayer!
    
    static func playRecording(name: String, identifier: Int) {
        do {
            player = try AVAudioPlayer(contentsOfURL: directoryURL(.Question, name: name, identifier: identifier)!)
            player.volume = 1.0
            player.prepareToPlay()
            player.play()
            print("playing sound <3")
        } catch let error as NSError {
            print("CRASH !" + error.localizedDescription)
        }
    }
}
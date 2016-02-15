//
//  Recorder.swift
//  GradeUp
//
//  Created by Adrien morel on 2/14/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import AVFoundation


class Recorder: NSObject, AVAudioRecorderDelegate {
    
    let recordFile = "demo.caf"
    var recorder: AVAudioRecorder? = nil
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    override init() {
        
        super.init()
        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                //self.setSessionPlayAndRecord()
                //self.setupRecorder()
            } else {
                print("Permission to record not granted")
            }
        })
        
    }
    
    func startRecording() {
        
        do {
            recorder = try AVAudioRecorder(URL: NSURL(fileURLWithPath: "bonjour"), settings: recordSettings)
            recorder!.delegate = self
            recorder!.meteringEnabled = true
            recorder!.prepareToRecord() // creates/overwrites the file at soundFileURL
            recorder!.record()
            print("recording...")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
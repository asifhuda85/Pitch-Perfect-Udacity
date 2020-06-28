//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Md Asif Huda on 6/27/20.
//  Copyright © 2020 Md Asif Huda. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var startRecordingButton: UIButton?
    @IBOutlet weak var recordingStateLabel: UILabel?
    @IBOutlet weak var stopRecordingButton: UIButton?
    
    var audioRecorder: AVAudioRecorder?
    
    let audioSession = AVAudioSession.sharedInstance()

    private enum recordingState {
        case notRecording
        case recording
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioRecorder()
        hanldeRecodingState(currentState: recordingState.notRecording)
    }

    @IBAction func startRecording(_ sender: Any) {
        hanldeRecodingState(currentState: recordingState.recording)
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        hanldeRecodingState(currentState: recordingState.notRecording)
        audioRecorder?.stop()
        try! audioSession.setActive(false)
    }
    
    private func hanldeRecodingState(currentState: recordingState) {
        switch currentState {
        case .notRecording:
            startRecordingButton?.isEnabled = true
            stopRecordingButton?.isEnabled = false
            recordingStateLabel?.text = "Tap to continue"
        case .recording:
            stopRecordingButton?.isEnabled = true
            startRecordingButton?.isEnabled = false
            recordingStateLabel?.text = "Recording in Progress"
        }
    }
    
    private func setupAudioRecorder() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                      mode: AVAudioSession.Mode.default,
                                      options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder?.delegate = self
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder?.url)
        } else {
            print("recoding was not succeessful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as? PlaySoundsViewController
            let recordedAudioURL = sender as? URL
            playSoundVC?.recordedAudioURL = recordedAudioURL
        }
    }
}


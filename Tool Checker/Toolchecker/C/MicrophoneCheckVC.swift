//
//  MicrophoneCheckVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 12/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class MicrophoneCheckVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    
    @IBOutlet weak var play_btn_ref: UIButton!
    @IBOutlet weak var record_btn_ref: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func recordButtonAction(_ sender: UIButton) {
        print("Record button pressed")
        if(isRecording)
        {
            finishAudioRecording(success: true)
            record_btn_ref.setTitle("Record", for: .normal)
            play_btn_ref.isEnabled = true
            isRecording = false
        }
        else
        {
            print("Setting up recorder")
            setup_recorder()
            
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            record_btn_ref.setTitle("Stop", for: .normal)
            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        print("playing audio")
        if(isPlaying)
        {
            audioPlayer.stop()
            record_btn_ref.isEnabled = true
            play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        }
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                record_btn_ref.isEnabled = false
                play_btn_ref.setTitle("Pause", for: .normal)
                prepare_play()
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: ["OK"])
            }
        }
    }
    
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MicrophoneCheckVC") as? MicrophoneCheckVC else {
            return UIViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.check_record_permission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            timerLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func check_record_permission()
    {
        print("Record permission")
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL
    {
        let filename = "TestRecord.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            _ = AVAudioSession.sharedInstance()
            do
            {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
//                try session.setCategory(AVAudioSession.Category.playAndRecord, with: .defaultToSpeaker)
//                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: ["OK"])
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: ["OK"])
        }
    }
    
    func display_alert(msg_title : String , msg_desc : String , action_title : [String])
    {
        var ac: UIAlertController!
        for title in action_title {
            ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: title, style: .default)
            {
                (result : UIAlertAction) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
        
        present(ac, animated: true)
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: ["OK"])
        }
    }
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        play_btn_ref.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        record_btn_ref.isEnabled = true
        display_alert(msg_title: "Microphone Test", msg_desc: "Did you hear your recording?", action_title: ["Yes", "No"])
    }

}

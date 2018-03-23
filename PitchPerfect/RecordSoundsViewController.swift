//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Алина Часова on 21.03.2018.
//  Copyright © 2018 innolina. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!         //'tep to record' label
    @IBOutlet weak var recordButton: UIButton!          //'record' button
    @IBOutlet weak var stopRecordingButton: UIButton!   //'stop recording' button
    var audioRecorder: AVAudioRecorder!                 //record
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //disabling 'stop recording' button
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        print("record button was pressed")
        //change 'tap to record' label, when 'record' button pushed
        recordingLabel.text = "Recording in progress"
        
        //re-enable 'stop recording' button, when 'record' button pushed
        //disable 'record' button, when it is pushed
        controlButton(record: false, stop: true)
        
        //find path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //name of the record
        let recordingName = "recordedVoice.wav"
        //pass path and name of the record into array
        let pathArray = [dirPath, recordingName]
        //create URL from path w/ name of record
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        //session to work w/ audio
        let session = AVAudioSession.sharedInstance()
        //actually playing and recording audion
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //delegate to know when stopped saving file to path
        audioRecorder.delegate = self
        //record
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecord(_ sender: AnyObject) {
        print("stop recording button was stopped")
        
        //disable 'stop recording' button, when it is pushed
        //re-enable 'record' button, when 'stop recording' is pushed
        controlButton(record: true, stop: false)
        
        //update label to 'tap to record'
        recordingLabel.text = "Tap to record"
        
        //stop recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func controlButton(record: Bool, stop: Bool) {
        recordButton.isEnabled = record
        stopRecordingButton.isEnabled = stop
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //check if the recording was saved and recorded correctly
        if flag {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    /*
    / function to be called, when the transition from
    / records sound VC to play sound VC is made
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if the transition that is performed is the right one
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}


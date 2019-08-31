//
//  ViewController.swift
//  SuperPowered
//
//  Created by JBach on 9/25/17.
//  Copyright © 2017 JBach. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let listFilterString = ["Resonant_Lowpass",
                            "Resonant_Highpass",
                            "Bandlimited_Bandpass",
                            "Bandlimited_Notch",
                            "LowShelf",
                            "HighShelf",
                            "Parametric"]
    let listFilterType = [Resonant_Lowpass,
                          Resonant_Highpass,
                          Bandlimited_Bandpass,
                          Bandlimited_Notch,
                          LowShelf,
                          HighShelf,
                          Parametric]
    
    var superpowered: FrequencyDomain!
    var startedRecord = false
    var audioPlayer: AVAudioPlayer!
    
    // MARK: - Filter
    var filterType: FilterType = Parametric
    var frequency: Float = 10000
    var octave: Float = 10
    var decibel: Float = 10
    var resonace: Float = 10
    var dbGain: Float = 10
    var slope: Float = 10
    var filterEnable = true
    
    // MARK: - Flanger
    var wet: Float = 0.5 {
        didSet {
            wetFlangerLabel.text = String(format:"%.2f", wet)
        }
    }
    
    var LFOBeats: Float = 32 {
        didSet {
            FLOBeatsFlangerLabel.text = String(format:"%.2f", LFOBeats)
        }
    }
    
    var depth: Float = 0.5 {
        didSet {
            depthFlangerLabel.text = String(format:"%.2f", depth)
        }
    }
    
    var flangerEnable = true
    
    //MARK: -Reverb
    var mixReverbs: Float = 0.5 {
        didSet {
            mixReverbsLabel.text = String(format:"%.2f", mixReverbs)
        }
    }
    
    var dampReverbs: Float = 0.5 {
        didSet {
            dampReverbsLabel.text = String(format:"%.2f", dampReverbs)
        }
    }
    
    var roomSize: Float = 0.5 {
        didSet {
            roomSizeReverbsLabel.text = String(format:"%.2f", roomSize)
        }
    }
    var reverbsEnable = true
    
    // MARK: - Echos
    var mixEcho: Float = 0.5 {
        didSet {
            mixEchoLabel.text = String(format:"%.2f", mixEcho)
        }
    }
    
    var echoEnable = true
    
    // MARK: - Gate
    var gateRnable = false
    
    // MARK: - Roll
    var rollEnable = false
    
    // MARK: - BandEQ
    var bandEQEnable = true
    
    var lowEQ: Float = 0.5 {
        didSet {
            lowEQLabel.text = String(format:"%.2f", lowEQ)
        }
    }
    
    var midEQ: Float = 0.5 {
        didSet {
            midEQLabel.text = String(format:"%.2f", midEQ)
        }
    }
    
    var highEQ: Float = 0.5 {
        didSet {
            highEQLabel.text = String(format:"%.2f", highEQ)
        }
    }
    
    
    // MARK: - Initial Variables
    var isValueChange = false {
        didSet {
            setup()
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var filterTypePicker: UIPickerView!
    
    @IBOutlet weak var wetFlangerLabel: UILabel!
    @IBOutlet weak var FLOBeatsFlangerLabel: UILabel!
    @IBOutlet weak var depthFlangerLabel: UILabel!
    
    @IBOutlet weak var mixReverbsLabel: UILabel!
    @IBOutlet weak var dampReverbsLabel: UILabel!
    @IBOutlet weak var roomSizeReverbsLabel: UILabel!
    
    @IBOutlet weak var mixEchoLabel: UILabel!
    
    @IBOutlet weak var lowEQLabel: UILabel!
    @IBOutlet weak var midEQLabel: UILabel!
    @IBOutlet weak var highEQLabel: UILabel!
    
    @IBOutlet weak var reverbsSwitch: UISwitch!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var echoSwitch: UISwitch!
    @IBOutlet weak var flangerSwitch: UISwitch!
    @IBOutlet weak var gateSwitch: UISwitch!
    @IBOutlet weak var rollSwitch: UISwitch!
    @IBOutlet weak var bandEQSwitch: UISwitch!
    
    //MARK: - LifeCycle@
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioURL = Bundle.main.path(forResource: "emoiVuCatTuong", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioURL!))
            audioPlayer.volume = 0.8
        } catch {
            print(error.localizedDescription)
        }
        
        superpowered = FrequencyDomain()
        setup()
        
        filterType = Parametric
        
        filterTypePicker.dataSource = self
        filterTypePicker.delegate = self
        
        filterTypePicker.selectRow(Int(listFilterString.count / 2), inComponent: 0, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func start() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            superpowered.pauseRecordAudio()
        } else {
            if startedRecord {
                superpowered.resumeRecordAudio()
            }
            audioPlayer.play()
        }
        
        if !startedRecord {
            superpowered.startRecordAudio()
            startedRecord = true
        }
    }
    
    @IBAction func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(0)
        if startedRecord {
            startedRecord = false
            superpowered.stopRecordAudio()
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
                self.performSegue(withIdentifier: "Player", sender: nil)
            }
        }
    }
    
    @IBAction func changeFilterValue(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            frequency = Float(sender.text!)!
        case 2:
            octave = Float(sender.text!)!
        case 3:
            decibel = Float(sender.text!)!
        case 4:
            resonace = Float(sender.text!)!
        case 5:
            dbGain = Float(sender.text!)!
        case 6:
            slope = Float(sender.text!)!
        default:
            return
        }
        isValueChange = !isValueChange
    }
    
    @IBAction func changeValue(_ sender: UISlider) {
        
        switch sender.tag {
        case 1:
            wet = sender.value
        case 2:
            LFOBeats = sender.value
        case 3:
            depth = sender.value
        case 4:
            mixEcho = sender.value
        case 5:
            mixReverbs = sender.value
        case 6:
            dampReverbs = sender.value
        case 7:
            roomSize = sender.value
        case 8:
            lowEQ = sender.value
        case 9:
            midEQ = sender.value
        case 10:
            highEQ = sender.value
        default:
            return
        }
    }
    
    @IBAction func endChangeValue(_ sender: Any) {
        isValueChange = !isValueChange
    }
    
    @IBAction func turnOnOffEffect(_ sender: UISwitch) {
        
        switch sender {
        case filterSwitch:
            filterEnable = sender.isOn ? true : false
        case flangerSwitch:
            flangerEnable = sender.isOn ? true : false
        case echoSwitch:
            echoEnable = sender.isOn ? true : false
        case bandEQSwitch:
            bandEQEnable = sender.isOn ? true : false
        case reverbsSwitch:
            reverbsEnable = sender.isOn ? true : false
        case gateSwitch:
            gateRnable = sender.isOn ? true : false
        case rollSwitch:
            rollEnable = sender.isOn ? true : false
        default:
            return
        }
        isValueChange = !isValueChange
    }
    
    // MARK: - event
    
    func setup() {
        //superpowered.setupGate(gateRnable)
        //superpowered.setupRoll(rollEnable)
        superpowered.setupEchos(mixEcho, enable: echoEnable)
        superpowered.setupReverbs(mixReverbs, dampReverbs, roomSize, enable: reverbsEnable)
        //superpowered.setupFilters(filterType, withFrequency: frequency, octave: octave, decibel: decibel, resonance: resonace, slope: slope, dbGain: dbGain, enable: filterEnable)
        //superpowered.setupFlanger(wet, lfoBeats: LFOBeats, depth: depth, enable: filterEnable)
        superpowered.setBandEQWithLowEQ(lowEQ, midEQ: midEQ, highEQ: highEQ, enable: bandEQEnable)
    }
    
    func cleanUp() {
        superpowered.stop()
        superpowered = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Player" {
            let destination = segue.destination as! PlayerViewController
            destination.urlRecord = URL(string: NSTemporaryDirectory() + superpowered.audioFilePath + ".wav")
        }
     }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listFilterType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterType = listFilterType[row]
        setup()
        print(filterType.rawValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        
        label.text = listFilterString[row]
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }
}


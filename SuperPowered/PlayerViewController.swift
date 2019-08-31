//
//  PlayerViewController.swift
//  SuperPowered
//
//  Created by JBach on 10/20/17.
//  Copyright © 2017 JBach. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    var urlRecord: URL!
    
    var audioPlayer: AVAudioPlayer!
    var mp3Player: AVAudioPlayer!
    
    var isPlay: Bool = false {
        didSet {
            if isPlay {
                mp3Player.play()
                audioPlayer.play()
            } else {
                mp3Player.pause()
                audioPlayer.pause()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(url: urlRecord)
        let url = Bundle.main.path(forResource: "emoiVuCatTuong", ofType: "mp3")
        do {
            mp3Player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mp3Player.stop()
        mp3Player = nil
        audioPlayer.stop()
        audioPlayer = nil
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: urlRecord.absoluteString) {
                // Delete file
                try fileManager.removeItem(atPath: urlRecord.absoluteString)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    @IBAction func play() {
        isPlay = !isPlay
    }
    
    @IBAction func stop() {
        mp3Player.stop()
        mp3Player.currentTime = TimeInterval(0)
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(0)
    }
    
    func setup(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}

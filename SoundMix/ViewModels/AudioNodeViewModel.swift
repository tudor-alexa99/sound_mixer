//
//  AudioNodeViewModel.swift
//  SoundMix
//
//  Created by Tudor Alexa on 11.03.2022.
//

import AVFAudio
import Foundation
import SwiftUI

class AudioNodeViewModel: NSObject, Identifiable, ObservableObject, AVAudioPlayerDelegate {
    let id = UUID()
    var sound: Sound
    var isPlaying = false {
        willSet {
            withAnimation {
                objectWillChange.send()
            }
        }
    }

    var audioPlayer: AVAudioPlayer?
    @Published var playerProgress: Double = 0.00

    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioSeekFrame: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0
    
    var audioLengthSeconds: Double = 0.0

    init(sound: Sound) {
        self.sound = sound

        super.init()
        // setup the audio metering
        setupAudioPlayer()
        setupAudioMeteringSamples()
    }

    init(url: URL, audioName: String? = nil) {
        sound = Sound(url: url)
        if let audioName = audioName {
            sound.name = audioName
        }

        super.init()
    }

    func setupAudioMeteringSamples() {
    }

    func playOrPauseAudio() {
        guard audioPlayer != nil else {
            setupAudioPlayer()
            return
        }

        isPlaying ? pauseAudio() : playAudio()
    }

    func setupAudioPlayer() {
        guard let soundUrl = sound.url else { return }

        if soundUrl.startAccessingSecurityScopedResource() {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            } catch {
                print(error.localizedDescription)
                do {
                    let audioFile =  try AVAudioFile(forReading: soundUrl)
                } catch {
                    print(error.localizedDescription)
                }
            }
            // set the delegate to self
            audioPlayer?.delegate = self

            // update the progress view
            let updater = CADisplayLink(target: self, selector: #selector(updateProgress))

            // get the audio duration, sample rate and length in seconds of the audio file
            audioLengthSeconds = audioPlayer?.duration ?? 0.0
            print("audio length in seconds: \(audioLengthSeconds)")

            // set the FPS to the display rate of the device
            let refreshRate = UIScreen.screens[0].maximumFramesPerSecond
            updater.preferredFramesPerSecond = max(refreshRate, 60)

            updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

            soundUrl.stopAccessingSecurityScopedResource()
        } else {
            print("Unable to access security scoped resource!")
        }
    }

    func playAudio() {
        guard let audioPlayer = audioPlayer else {
            return
        }

        print("Audio player current time: \(audioPlayer.currentTime)")

        if !audioPlayer.isPlaying && !isPlaying {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        }
    }

    func pauseAudio(didReachEnd: Bool = false) {
        guard let audioPlayer = audioPlayer else {
            return
        }

        if audioPlayer.isPlaying && isPlaying {
            audioPlayer.pause()
            isPlaying = false
        }
    }

    @objc func updateProgress() {
        guard let audioPlayer = audioPlayer else {
            return
        }

        let normalizedTime = Double(audioPlayer.currentTime / audioPlayer.duration)
        playerProgress = normalizedTime
    }

    @objc func seekToPosition(position: Double) {
        print("New position to seek to: \(position)")

        guard let audioPlayer = audioPlayer else {
            return
        }
        // pause the player
        pauseAudio()

        var seekFrame = audioLengthSeconds * position

        // if the user drags the progress to the end of the file, set the seek frame to the length of the audio
        // if the user drags the progress to the beginning, set the seek to 0.0
        seekFrame = max(seekFrame, 0.0)
        seekFrame = min(seekFrame, audioLengthSeconds - 0.1)

        print("Updated seek frame: \(seekFrame)")

        audioPlayer.currentTime = seekFrame
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // After successfully finish song playing will stop audio player and remove from memory
            audioPlayer?.stop()
            
            playerProgress = audioLengthSeconds
            isPlaying = false
            
            audioPlayer = nil
            setupAudioPlayer()
        }
    }
}

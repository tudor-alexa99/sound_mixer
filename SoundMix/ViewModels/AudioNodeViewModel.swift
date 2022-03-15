//
//  AudioNodeViewModel.swift
//  SoundMix
//
//  Created by Tudor Alexa on 11.03.2022.
//

import AVFAudio
import Foundation
import SwiftUI

class AudioNodeViewModel: NSObject, Identifiable, ObservableObject {
    let id = UUID()
    var sound: Sound
    var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    @Published var playerProgress: Double = 0.00

    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioSeekFrame: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0

    init(sound: Sound) {
        self.sound = sound

        super.init()
        // setup the audio metering
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
            }

            isPlaying = true
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()

            // update the progress view
            let updater = CADisplayLink(target: self, selector: #selector(updateProgress))

            // set the FPS to the display rate of the device
            let refreshRate = UIScreen.screens[0].maximumFramesPerSecond
            updater.preferredFramesPerSecond = max(refreshRate, 60)

            updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

            updateProgress()

        } else {
            print("Unable to access security scoped resource!")
        }
    }

    func playAudio() {
        guard let audioPlayer = audioPlayer else {
            return
        }

        if !audioPlayer.isPlaying && !isPlaying {
            audioPlayer.play()
            isPlaying = true
        }
    }

    func pauseAudio() {
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
    }
}

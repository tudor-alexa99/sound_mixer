//
//  MasterSoundViewModel.swift
//  SoundMix
//
//  Created by Tudor Alexa on 16.03.2022.
//

import AVFAudio
import Foundation

class MasterSoundViewModel: NSObject, Identifiable, ObservableObject, AVAudioPlayerDelegate {
    let id = UUID()
    private var totalTimelineAudioLength: Double = 0.0
    let currentTimelinePosition: Double = 0.0
    private var audioEngine = AVAudioEngine()

    private var audioList: AudioListViewModel = AudioListViewModel()

    override init() {
        super.init()
    }

    init(audioList: AudioListViewModel) {
        self.audioList = audioList
        super.init()
        setupAudio()
    }

    // MARK: - Prepare audio engine and files
    
    private func setupAudio() {
        for audioVM in audioList.audioList {
            totalTimelineAudioLength += audioVM.audioLengthSeconds
        }
        print("Total audio playback time: \(totalTimelineAudioLength)")
    }
    
    // MARK: - Audio playback

    func playAllAudioTracks() {
        let audioFile = audioList.audioList[0].audioFile
        let playerNode = AVAudioPlayerNode()

        // attach the player node to the audio engine
        audioEngine.attach(playerNode)

        // connect the player node to the output node
        audioEngine.connect(playerNode,
                            to: audioEngine.outputNode,
                            format: audioFile?.processingFormat)

        // schedule the file for full playback
        do {
            try audioEngine.start()
            playerNode.scheduleFile(audioFile!, at: nil)
            playerNode.play()
        } catch {
            print("Error setting up the audio engine \(error.localizedDescription)")
        }
    }
}

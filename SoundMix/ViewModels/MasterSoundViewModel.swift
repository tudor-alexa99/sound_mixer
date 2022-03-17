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
        let audioFile1 = audioList.audioList[0].audioFile
        let audioFile2 = audioList.audioList[1].audioFile

        let playerNode1 = AVAudioPlayerNode()
        let playerNode2 = AVAudioPlayerNode()

        // create a mixer node to combine the existing nodes together
        let mixerNode = AVAudioMixerNode()

        // attach the player node to the audio engine
        audioEngine.attach(playerNode1)
        audioEngine.attach(playerNode2)
        audioEngine.attach(mixerNode)

        // connect the player node to the output node
        audioEngine.connect(playerNode1,
                            to: mixerNode,
                            format: audioFile1?.processingFormat)

        audioEngine.connect(playerNode2,
                            to: mixerNode,
                            format: audioFile2?.processingFormat)

        audioEngine.connect(mixerNode,
                            to: audioEngine.outputNode,
                            format: audioFile1?.processingFormat)

        // schedule the file for full playback
        do {
            try audioEngine.start()
            playerNode1.scheduleFile(audioFile1!, at: nil)
            playerNode2.scheduleFile(audioFile2!, at: nil)
            playerNode1.play()
            playerNode2.play()
        
            
            // schedule the mixer node instead
            
        } catch {
            print("Error setting up the audio engine \(error.localizedDescription)")
        }
    }
}

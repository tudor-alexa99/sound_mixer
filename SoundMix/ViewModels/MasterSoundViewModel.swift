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

    private var mixerNode = AVAudioMixerNode()
    private var playerNodesList: [AVAudioPlayerNode] = []

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

        // attach the player nodes to the audio engine
        attachAllNodes()

        // connect the player node to the output node
        connectAllNodes()

        // schedule the file for full playback
        do {
            try audioEngine.start()
            scheduleAllNodes()
            playAllScheduledNodes()
            // schedule the mixer node instead

        } catch {
            print("Error setting up the audio engine \(error.localizedDescription)")
        }
    }

    private func attachAllNodes() {
        audioList.audioList.forEach { _ in
            let audioPlayerNode = AVAudioPlayerNode()
            playerNodesList.append(audioPlayerNode)

            // attach each player node to the engine
            audioEngine.attach(audioPlayerNode)
        }

        // use the mixer node to combine all the audio nodes
        audioEngine.attach(mixerNode)
    }

    private func connectAllNodes() {
        // get the format to be used on the main mixer node
        guard audioList.audioList.count > 0 else { return }
        let format = audioList.audioList[0].audioFile!.processingFormat

        for index in playerNodesList.indices {
            // connect all the nodes to the mixer node
            audioEngine.connect(playerNodesList[index],
                                to: mixerNode,
                                format: audioList.audioList[index].audioFile?.processingFormat)
        }

        // connect the mixer node to the mainMixer / output node of the audio engine
        audioEngine.connect(mixerNode,
                            to: audioEngine.outputNode,
                            format: format)
    }

    private func scheduleAllNodes() {
        guard audioList.audioList.count > 0 else { return }

        for index in playerNodesList.indices {
            playerNodesList[index].scheduleFile(audioList.audioList[index].audioFile!, at: nil)
        }
    }

    private func playAllScheduledNodes() {
        guard audioList.audioList.count > 0 else { return }

        for playerNode in playerNodesList {
            playerNode.play()
        }
    }
}

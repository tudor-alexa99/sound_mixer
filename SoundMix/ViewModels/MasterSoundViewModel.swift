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
    var totalTimelineAudioLength: Double = 0.0
    let currentTimelinePosition: Double = 0.0

    var audioList: AudioListViewModel = AudioListViewModel()

    override init() {
        super.init()
    }

    init(audioList: AudioListViewModel) {
        self.audioList = audioList
        super.init()
        setupAudio()
    }

    private func setupAudio() {
        for audioVM in audioList.audioList {
            totalTimelineAudioLength += audioVM.audioLengthSeconds
        }
        print("Total audio playback time: \(totalTimelineAudioLength)")
    }

    func playAllAudioTracks() {
    }
}

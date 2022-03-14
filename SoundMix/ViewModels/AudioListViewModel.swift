//
//  AudioListViewModel.swift
//  SoundMix
//
//  Created by Tudor Alexa on 10.03.2022.
//

import Foundation
import SwiftUI

class AudioListViewModel: NSObject, ObservableObject {
    @Published var audioList: [AudioNodeViewModel]

    override init() {
        audioList = []
    }
}

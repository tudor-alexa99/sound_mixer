//
//  SoundwaveRow.swift
//  SoundMix
//
//  Created by Tudor Alexa on 09.03.2022.
//

import SwiftUI

struct SoundwaveRow: View {
    @ObservedObject var viewModel: AudioNodeViewModel

    @State var isPlaying: Bool = false

    init(viewModel: AudioNodeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Button(action: {
                print("Playing \(viewModel.sound.name)")
                viewModel.playOrPauseAudio()
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(Color("light_background_color"))
                    .padding()
                    .background(Color("main_background_color"))
                    .cornerRadius(5.0)
                    .padding(5)
            }
            VStack {
                SoundwaveSlider(value:$viewModel.playerProgress,
                                height: 40,
                                width: 200,
                                seekCompletion: viewModel.seekToPosition)
                    .padding()
            }

            Spacer()
        }
    }
}

// struct SoundwaveRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundwaveRow(audioFile: Sound(url: ))
//    }
// }

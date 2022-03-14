//
//  CircleButton.swift
//  SoundMix
//
//  Created by Tudor Alexa on 10.03.2022.
//

import Foundation
import SwiftUI

struct CircleButton: View {
    @State var circleTapped = false
    @State var circlePressed = false
    @State var showDocumentPicker = false

    @ObservedObject var viewModel: AudioListViewModel

    init(viewModel: AudioListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Image(systemName: "plus")
                .colorInvert()
                .font(.system(size: 40, weight: .light))
                .offset(x: circlePressed ? -90 : 0, y: circlePressed ? -90 : 0)
                .rotation3DEffect(Angle(degrees: circlePressed ? 20 : 0), axis: (x: 10, y: -10, z: 0))
        }
        .frame(width: 60, height: 60)
        .background(
            ZStack {
                Circle()
                    .fill(Color("secondary_background_color"))
                    .frame(width: 90, height: 90)
                    .shadow(color: Color("light_background_color"), radius: 4, x: -4, y: -4)
                    .shadow(color: Color("main_background_color"), radius: 4, x: 4, y: 8)
            }
        )
        .scaleEffect(circleTapped ? 0.98 : 1)
        .onTapGesture(count: 1) {
            self.circleTapped.toggle()
            self.showDocumentPicker = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.circleTapped = false
            }
        }
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.audio], allowsMultipleSelection: false, onCompletion: { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                let message = selectedFile.absoluteString
                var soundModel = Sound(url: selectedFile)
                soundModel.path = message
                self.viewModel.audioList.append(AudioNodeViewModel(sound: soundModel))
                self.viewModel.objectWillChange.send()

            } catch {
                // Handle failure.
            }
        })
    }
}

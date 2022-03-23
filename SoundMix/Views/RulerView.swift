//
//  RulerView.swift
//  SoundMix
//
//  Created by Tudor Alexa on 21.03.2022.
//

import SlidingRuler
import SwiftUI

struct RulerView: View {
    @State private var value: Double = 0

    var body: some View {
        TrackRow()
    }

    var rulerBody: some View {
        HStack {
            VStack {
                SlidingRuler(value: $value, in: 0 ... Double.infinity)
            }
            Spacer()
        }
    }
}

struct RulerView_Previews: PreviewProvider {
    static var previews: some View {
        RulerView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

struct TrackRow: View {
    @State var location = CGPoint.zero
    @State var xCoordinate = 0.0

    var body: some View {
        ZStack {
            VStack {
                SoundwaveSlider(value: .constant(0.3), seekCompletion: { _ in })
            }
            .border(.bar, width: 10)
            .position(x: xCoordinate, y: 100)
            .coordinateSpace(name: "stack")
            .contentShape(Rectangle())
            .zIndex(1)
            .gesture(dragGesture)
        }
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { info in
                location = info.location
                xCoordinate = info.location.x
                print(info.location)
            }
    }
}

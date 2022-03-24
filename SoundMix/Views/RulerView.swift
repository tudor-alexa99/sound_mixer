//
//  RulerView.swift
//  SoundMix
//
//  Created by Tudor Alexa on 21.03.2022.
//

import SlidingRuler
import SwiftUI

struct RulerView: View {
    var body: some View {
        TrackRow()
    }

//    var rulerBody: some View {
//        VStack {
//            SlidingRuler(value: $value, in: 0 ... Double.infinity)
//        }
//    }
}

struct RulerView_Previews: PreviewProvider {
    static var previews: some View {
        RulerView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct TrackRow: View {
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ForEach(1 ... 10, id: \.self) { _ in
                TrackRowUnit()
                    .background(Color.red)
            }
        }
        .accessibilityRespondsToUserInteraction()
//            .background(Color.red)
    }
}

struct TrackRowUnit: View {
    @State private var value: Double = 0
    @State var location = CGPoint.zero
    @State var xCoordinate = 0.0

    var body: some View {
        SoundwaveSlider(value: .constant(0.3), seekCompletion: { _ in })
            .border(.bar, width: 10)
            .position(x: xCoordinate, y: self.location.y)
            .coordinateSpace(name: "stack")
            .contentShape(Rectangle())
            .gesture(dragGesture)
            .simultaneousGesture(longPressGesture)
            .padding()
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .global)
            .onChanged { info in
                location = info.location
                xCoordinate = info.location.x
                print(info.location)
            }
            .onEnded { _ in
                print("Drag ended")
            }
    }

    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 2, maximumDistance: 1)
            .sequenced(before: dragGesture)
            .onEnded { _ in
                print("Long press")
//                self.location = position(x: xCoordinate, y: self.location.y) as! CGPoint
            }
    }
}

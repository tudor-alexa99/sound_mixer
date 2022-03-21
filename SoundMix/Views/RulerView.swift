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
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                SlidingRuler(value: $value)
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

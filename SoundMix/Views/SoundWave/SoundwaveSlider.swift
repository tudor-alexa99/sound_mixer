//
//  SoundwaveSlider.swift
//  SoundMix
//
//  Created by Tudor Alexa on 09.03.2022.
//

import Foundation
import SwiftUI

struct SoundwaveSlider: View {
    @Binding var value: Double
    @State var height: Double = 60
    @State var width: Double = 320
    
    var body: some View {
        let background = Color(red: 0.07, green: 0.07, blue: 0.12)
        return ZStack {
//            background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Group {
                    CustomSlider(value: $value, range: (0, 1), knobWidth: 0) { modifiers in
                        ZStack {
                            LinearGradient(gradient: .init(colors: [Color("pink_accent_color"), Color.purple]), startPoint: .leading, endPoint: .trailing)
                            Group {
                                background // = Color(red: 0.07, green: 0.07, blue: 0.12)
                                Color.white.opacity(0.2)
                                LinearGradient(gradient: .init(colors: [Color.gray.opacity(0.1), Color.black.opacity(0.6)]), startPoint: .bottom, endPoint: .top)
                            }
                            .modifier(modifiers.barRight)
                        }
                        .clipShape(MagnitudeChart()) // our shape from previous step will mask the bar via clipShape
                    }
                    .frame(height: height)
                }
                .frame(width: width)
            }
        }
    }
}

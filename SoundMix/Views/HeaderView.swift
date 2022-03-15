//
//  HeaderView.swift
//  SoundMix
//
//  Created by Tudor Alexa on 08.03.2022.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    @State var value: Double = 30

    var body: some View {
        VStack {
            upperHeaderView
            SoundwaveSlider(value: .constant(30.0), seekCompletion: { _ in })
                .padding(10)
        }.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color("secondary_background_color"), lineWidth: 0.5)
            }
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("secondary_background_color"))
            )
            .shadow(radius: 1)
    }

    var upperHeaderView: some View {
        VStack {
            HStack {
                Button(action: {
                    print("Play button pressed")
                }) {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("light_background_color"))
                        .padding()
                        .background(Color("main_background_color"))
                        .cornerRadius(5.0)
                }
                Text("Title of the song")
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

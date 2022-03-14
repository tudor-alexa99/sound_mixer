//
//  ContentView.swift
//  SoundMix
//
//  Created by Tudor Alexa on 08.03.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AudioListViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    SoundsList(viewModel: viewModel)
                        .navigationBarTitleDisplayMode(.automatic)
                        .navigationTitle("Sound mixer")
                    Spacer()
                }
                CircleButton(viewModel: viewModel)
                Spacer()
            }
        }
        .background(.regularMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

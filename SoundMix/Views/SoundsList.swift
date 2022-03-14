//
//  SoundsList.swift
//  SoundMix
//
//  Created by Tudor Alexa on 09.03.2022.
//

import Foundation
import SwiftUI

struct SoundsList: View {
    @ObservedObject var viewModel: AudioListViewModel

    init(viewModel: AudioListViewModel) {
        UITableView.appearance().backgroundColor = .secondarySystemBackground
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: HeaderView()) {
                        ForEach(viewModel.audioList, id: \.id) { viewModel in
                            SoundwaveRow(viewModel: viewModel)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

struct SoundList_Previews: PreviewProvider {
    static var previews: some View {
        SoundsList(viewModel: AudioListViewModel())
    }
}

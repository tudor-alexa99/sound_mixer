//
//  Sound.swift
//  SoundMix
//
//  Created by Tudor Alexa on 10.03.2022.
//

import Foundation
import SwiftUI

struct Sound {
    var name: String
    var path: String = ""
    var url: URL? = nil
    
    init(url: URL) {
        self.name = UUID().uuidString + "audio"
        self.url = url
    }
}



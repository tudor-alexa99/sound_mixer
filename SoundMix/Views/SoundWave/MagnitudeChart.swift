//
//  MagnitudeChart.swift
//  SoundMix
//
//  Created by Tudor Alexa on 09.03.2022.
//

import Foundation
import SwiftUI

struct MagnitudeChart: Shape {
    var values: [CGFloat] = [0, 2, 4, 1, 3, 5, 4, 3, 1, 3, 4, 5, 7, 9, 7, 9, 5, 3, 4, 7, 6, 3, 2, 3, 4, 5, 2, 3, 1, 1, 0]
    
    func displayCustomValues() {
        
    }
    
    func path(in rect: CGRect) -> Path {
        let maxValue = values.max() ?? 9
        let minValue = values.min() ?? 0
        var path = Path()
        path.move(to: rect.origin)
        for (index, value) in values.enumerated() {
            let padding = rect.height * (1 - value / (maxValue - minValue))
            let barWidth: CGFloat = 3
            let spacing = (rect.width - barWidth * CGFloat(values.count)) / CGFloat(values.count - 1)
            let barRect = CGRect(x: (CGFloat(barWidth) + spacing) * CGFloat(index),
                                 y: rect.origin.y + padding * 0.5,
                                 width: barWidth,
                                 height: rect.height - padding)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: 1, height: 1))
        }
        let bounds = path.boundingRect
        let scaleX = rect.size.width / bounds.size.width
        let scaleY = rect.size.height / bounds.size.height
        return path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}

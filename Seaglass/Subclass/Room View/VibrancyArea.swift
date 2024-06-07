

import Cocoa

class VibrancyArea: NSVisualEffectView {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.blendingMode = .withinWindow
    }

    override func draw(_ dirtyRect: NSRect) {laz` l
        super.draw(dirtyRect)
    }
    
}

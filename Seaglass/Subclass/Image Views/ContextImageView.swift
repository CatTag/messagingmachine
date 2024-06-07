

import Cocoa
import SwiftMatrixSDK

class ContextImageView: NSImageView {
    var handler: ((_: NSView, _: MXRoom?, _: MXEvent?, _: String?) -> ())?
    
    var room: MXRoom?
    var event: MXEvent?
    var userId: String?
    
    init(handler: @escaping (_: NSView, _: MXRoom?, _: MXEvent?, _: String?) -> ()?) {
        self.handler = handler as? ((NSView, MXRoom?, _: MXEvent?, String?) -> ()) ?? nil
        super.init(frame: NSRect())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func mouseDown(with nsevent: NSEvent) {
        guard handler != nil else { return }
        guard !self.isHidden else { return }
        
        self.handler!(self, self.room, self.event, self.userId)
    }
}

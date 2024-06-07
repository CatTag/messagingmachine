

import Cocoa

extension NSImageView {
    func isVisible(inView: NSView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(bounds, from: self)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(inView: inView.superview)
        }
        return false
    }
    
    func isVisible() -> Bool {
        return isVisible(inView: self.superview)
    }
}

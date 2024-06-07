

import Cocoa

class LoginWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.hide(nil)
        return false
    }
    
    
    
}

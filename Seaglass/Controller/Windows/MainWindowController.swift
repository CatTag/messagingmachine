

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("Main window should close?")
        NSApplication.shared.hide(nil)
        return false
    }
    
    func windowWillClose(_ notification: Notification) {
        print("Main window will close")
    }

}

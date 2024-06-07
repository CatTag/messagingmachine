

import Cocoa

class UserSettingsWindowController: NSWindowController, NSToolbarDelegate {

    @IBOutlet var toolbar: NSToolbar!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let window = self.window {
            if toolbar.items.count == 0 {
                toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.flexibleSpace, at: 0)
                toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.init("SeaglassPreferences"), at: 1)
                toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.flexibleSpace, at: 2)
            }
            
            window.toolbar = toolbar
        }
    }

    @IBAction func didChangeTabs(_ sender: NSSegmentedControl) {
        if let controller = self.window!.contentViewController as? UserSettingsTabViewController {
            controller.tabView.selectTabViewItem(at: sender.selectedSegment)
        }
    }
}

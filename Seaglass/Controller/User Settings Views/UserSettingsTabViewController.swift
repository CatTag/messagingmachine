

import Cocoa

class UserSettingsTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabView.tabViewType = .noTabsNoBorder
        self.selectedTabViewItemIndex = 0
    }
    
    override func viewWillAppear() {
        if let item = self.tabView.selectedTabViewItem {
            resizeWindowToFit(tabViewItem: item)
        }
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if let item = tabViewItem {
            resizeWindowToFit(tabViewItem: item)
        }
    }

    private func resizeWindowToFit(tabViewItem: NSTabViewItem?) {
        guard let window = view.window else { return }
        
        if let controller = tabViewItem?.viewController as? UserSettingsTabController, let size = controller.resizeToSize {
            let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
            let frame = window.frameRect(forContentRect: rect)
            let toolbar = window.frame.size.height - frame.size.height
            let origin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + toolbar)
            
            window.setFrame(NSRect(origin: origin, size: frame.size), display: false, animate: true)
        }
    }
    
}

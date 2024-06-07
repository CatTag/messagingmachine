

import Cocoa

class MenuController: NSMenu {
    
	@IBAction func focusOnRoomSearchField(_ sender: NSMenuItem) {
		sender.target = self

		let mainWindow = NSApplication.shared.mainWindow
		let splitViewController = mainWindow?.contentViewController as? NSSplitViewController
		let mainRoomsViewController = splitViewController?.splitViewItems.first?.viewController as? MainViewRoomsController

		if let searchField = mainRoomsViewController?.RoomSearch {
			searchField.selectText(sender)

			let lengthOfInput = NSString(string: searchField.stringValue).length
			searchField.currentEditor()?.selectedRange = NSMakeRange(lengthOfInput, 0)
		}
	}
    
    @IBAction func inviteButtonClicked(_ sender: NSMenuItem) {
        MatrixServices.inst.mainController?.channelDelegate?.uiRoomStartInvite()
    }
    
    @IBAction func gotoOldestLoaded(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared.mainWindow
        let splitViewController = mainWindow?.contentViewController as? NSSplitViewController
        let mainRoomViewController = splitViewController?.splitViewItems.last?.viewController as? MainViewRoomController
        
        mainRoomViewController?.RoomMessageTableView.scrollToBeginningOfDocument(self)
    }
    
    @IBAction func gotoNewest(_ sender: NSMenuItem) {
        let mainWindow = NSApplication.shared.mainWindow
        let splitViewController = mainWindow?.contentViewController as? NSSplitViewController
        let mainRoomViewController = splitViewController?.splitViewItems.last?.viewController as? MainViewRoomController
        
        mainRoomViewController?.RoomMessageTableView.scrollToEndOfDocument(self)
    }	
    
}

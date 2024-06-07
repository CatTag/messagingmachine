

import Cocoa

class RoomAliasEntry: NSTableCellView {
    @IBOutlet var RoomAliasName: NSTextField!
    @IBOutlet var RoomAliasPrimary: NSButton!
    @IBOutlet var RoomAliasDelete: NSButton!
    
    public var parent: RoomAliasesController?
    
    @IBAction func makePrimary(_ sender: NSButton) {
        parent?.primaryButtonClicked(sender: self)
    }
    
    @IBAction func delete(_ sender: NSButton) {
        parent?.deleteButtonClicked(sender: self)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        RoomAliasName.isEditable = true
    }
}

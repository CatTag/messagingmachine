

import Cocoa

class RoomListEntry: NSTableCellView {
    @IBOutlet var RoomListEntryName: NSTextField!
    @IBOutlet var RoomListEntryTopic: NSTextField!
    @IBOutlet var RoomListEntryIcon: AvatarImageView!
    @IBOutlet var RoomListEntryUnread: NSImageView!
    
    var roomsCacheEntry: RoomsCacheEntry?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

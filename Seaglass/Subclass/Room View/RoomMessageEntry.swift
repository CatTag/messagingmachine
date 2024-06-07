

import Cocoa

class RoomMessageEntry: NSTableCellView {
    @IBOutlet var RoomMessageEntryInboundFrom: NSTextField!
    @IBOutlet var RoomMessageEntryInboundText: NSTextField!
    @IBOutlet var RoomMessageEntryInboundIcon: AvatarImageView!
    @IBOutlet var RoomMessageEntryInboundPadlock: ContextImageView!
    @IBOutlet var RoomMessageEntryInboundTextConstraint: NSLayoutConstraint!
    @IBOutlet var RoomMessageEntryInboundTime: NSTextField!
    
    @IBOutlet var RoomMessageEntryInboundCoalescedText: NSTextField!
    @IBOutlet var RoomMessageEntryInboundCoalescedPadlock: ContextImageView!
    @IBOutlet var RoomMessageEntryInboundCoalescedTextConstraint: NSLayoutConstraint!
    @IBOutlet var RoomMessageEntryInboundCoalescedTime: NSTextField!
    
    @IBOutlet var RoomMessageEntryOutboundFrom: NSTextField!
    @IBOutlet var RoomMessageEntryOutboundText: NSTextField!
    @IBOutlet var RoomMessageEntryOutboundIcon: AvatarImageView!
    @IBOutlet var RoomMessageEntryOutboundPadlock: ContextImageView!
    @IBOutlet var RoomMessageEntryOutboundTextConstraint: NSLayoutConstraint!
    @IBOutlet var RoomMessageEntryOutboundTime: NSTextField!
    
    @IBOutlet var RoomMessageEntryOutboundMediaFrom: NSTextField!
    @IBOutlet var RoomMessageEntryOutboundMediaCollection: NSCollectionView!
    @IBOutlet var RoomMessageEntryOutboundMediaIcon: AvatarImageView!
    @IBOutlet var RoomMessageEntryOutboundMediaPadlock: ContextImageView!
    @IBOutlet var RoomMessageEntryOutboundMediaTime: NSTextField!
    
    @IBOutlet var RoomMessageEntryOutboundCoalescedText: NSTextField!
    @IBOutlet var RoomMessageEntryOutboundCoalescedPadlock: ContextImageView!
    @IBOutlet var RoomMessageEntryOutboundCoalescedTextConstraint: NSLayoutConstraint!
    @IBOutlet var RoomMessageEntryOutboundCoalescedTime: NSTextField!
    
    
    
    @IBOutlet var RoomMessageEntryInlineText: NSTextField!
}

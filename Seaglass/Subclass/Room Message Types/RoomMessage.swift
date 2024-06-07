

import Cocoa
import SwiftMatrixSDK

class RoomMessage: NSTableCellView {
    var event: MXEvent?
    var drawnEvent: MXEvent?
    var drawnEventHash: Int = 0
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func viewWillDraw() {
    }
    
    func updateIcon() {
        
    }
    
    func encryptionIsBlacklisted() -> Bool {
        guard event != nil && event!.isEncrypted else { return false }
        if let deviceInfo = MatrixServices.inst.session.crypto.eventSenderDevice(of: event) {
            return deviceInfo.verified == MXDeviceBlocked
        }
        return false
    }
    
    func encryptionIsEncrypted() -> Bool {
        guard event != nil else { return false }
        return event!.sentState == MXEventSentStateEncrypting || event!.isEncrypted
    }
    
    func encryptionIsPending() -> Bool {
        guard event != nil else { return false }
        return event!.type == "m.room.encrypted" || event!.decryptionError != nil
    }
    
    func encryptionIsVerified() -> Bool {
        guard event != nil else { return false }
        if let deviceInfo = MatrixServices.inst.session.crypto.eventSenderDevice(of: event!) {
            return self.encryptionIsEncrypted() && deviceInfo.verified == MXDeviceVerified
        } else {
            return false
        }
    }
    
    func encryptionIsSending() -> Bool {
        guard event != nil else { return false }
        return event!.sentState != MXEventSentStateSent && event!.isLocalEvent()
    }
    
    func icon() -> (image: NSImage, width: CGFloat, height: CGFloat) {
        let padlockWidth: CGFloat = 16
        let padlockHeight: CGFloat = 12
        let padlockColor: NSColor =
            self.encryptionIsPending() ? NSColor.systemGray.withAlphaComponent(0.5) :
            self.encryptionIsSending() ? NSColor(deviceRed: 0.38, green: 0.65, blue: 0.53, alpha: 0.75) :
            self.encryptionIsBlacklisted() ? NSColor.systemRed :
            (self.encryptionIsEncrypted() ?
                (self.encryptionIsVerified() ?
                    NSColor(deviceRed: 0.38, green: 0.65, blue: 0.53, alpha: 0.75) :
                    NSColor(deviceRed: 0.89, green: 0.75, blue: 0.33, alpha: 0.75)
                ) : NSColor(deviceRed: 0.79, green: 0.31, blue: 0.27, alpha: 0.75))
        let padlockImage: NSImage = self.encryptionIsEncrypted() ?
            NSImage(named: NSImage.lockLockedTemplateName)!.tint(with: padlockColor) :
            NSImage(named: NSImage.lockUnlockedTemplateName)!.tint(with: padlockColor)
        return (padlockImage, padlockWidth, padlockHeight)
    }
    
    func from() -> String {
        if event == nil {
            return ""
        }
        if let room = MatrixServices.inst.session.room(withRoomId: event!.roomId) {
            return room.state.memberName(event!.sender) ?? event!.sender as String
        }
        return ""
    }
    
    func timestamp(_ timeStyle: DateFormatter.Style = .short, andDate dateStyle: DateFormatter.Style = .none) -> String {
        if event == nil {
            return "XX:XX"
        }
        
        let eventTime = Date(timeIntervalSince1970: TimeInterval(event!.originServerTs / 1000))
        let eventTimeFormatter = DateFormatter()
        eventTimeFormatter.timeZone = TimeZone.current
        eventTimeFormatter.timeStyle = timeStyle
        eventTimeFormatter.dateStyle = dateStyle
        
        return eventTimeFormatter.string(from: eventTime)
    }
    
    func textContent() -> (string: String?, attributedString: NSAttributedString?) {
        if event == nil {
            return (nil, nil)
        }
        
        var cellAttributedStringValue: NSAttributedString? = nil
        var cellStringValue: String? = nil
      
        /*
        if event!.content["formatted_body"] != nil {
            let justification = event!.sender == MatrixServices.inst.client?.credentials.userId ? NSTextAlignment.right : NSTextAlignment.left
            cellAttributedStringValue = (event!.content["formatted_body"] as! String).trimmingCharacters(in: .whitespacesAndNewlines).toAttributedStringFromHTML(justify: justification)
            cellStringValue = (event!.content["formatted_body"] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        } else if event!.content["body"] != nil {
            cellStringValue = (event!.content["body"] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
            cellAttributedStringValue = NSAttributedString(string: cellStringValue!)
        }
        */
        
        if event!.content["body"] != nil {
            let justification = event!.sender == MatrixServices.inst.client?.credentials.userId ? NSTextAlignment.right : NSTextAlignment.left
            let color = event!.content["msgtype"] as? String ?? "m.text" == "m.notice" ? NSColor.headerColor : NSColor.textColor
            cellStringValue = (event!.content["body"] as! String)
            cellAttributedStringValue = (event!.content["body"] as! String).trimmingCharacters(in: .whitespacesAndNewlines).toAttributedStringFromMarkdown(justify: justification, color: color)
        }
        
        return (cellStringValue, cellAttributedStringValue)
    }
    
    func emoteContent(align: NSTextAlignment = .left) -> NSAttributedString {
        let para = NSMutableParagraphStyle()
        para.alignment = align
        
        let text = NSMutableAttributedString(string: "* ", attributes: [ .paragraphStyle: para, .foregroundColor: NSColor.headerColor ])
        text.append(self.textContent().attributedString!)
        text.append(NSMutableAttributedString(string: " *", attributes: [ .foregroundColor: NSColor.headerColor ]))

        return text
    }
}



import Cocoa
import SwiftMatrixSDK

class MainViewInviteController: NSViewController {

    @IBOutlet weak var InviteeMatrixID: NSTextField!
    @IBOutlet weak var InviteButton: NSButton!
    @IBOutlet weak var CancelButton: NSButton!
    @IBOutlet weak var InviteSpinner: NSProgressIndicator!
    
    var roomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for control in [ InviteeMatrixID, InviteButton, CancelButton ] as [NSControl] {
            control.isEnabled = true
        }
        InviteSpinner.isHidden = true
    }
    
    @IBAction func inviteButtonClicked(_ sender: NSButton) {
        guard sender == InviteButton else { return }
        guard roomId != "" else { return }
        
        let invitee = MXRoomInvitee.userId(String(InviteeMatrixID.stringValue).trimmingCharacters(in: .whitespacesAndNewlines))
        
        for control in [ InviteeMatrixID, InviteButton, CancelButton ] as [NSControl] {
            control.isEnabled = false
        }
        InviteSpinner.isHidden = false
        InviteSpinner.startAnimation(self)
        
        let group = DispatchGroup()
        
        group.enter()
        MatrixServices.inst.session.room(withRoomId: roomId).invite(invitee) { (response) in
            if response.isFailure {
                let alert = NSAlert()
                alert.messageText = "Failed to invite user"
                alert.informativeText = response.error!.localizedDescription
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
            group.leave()
        }
        
        group.notify(queue: .main, execute: {
            self.InviteSpinner.isHidden = true
            self.InviteSpinner.stopAnimation(self)
            
            sender.window?.contentViewController?.dismiss(sender)
        })
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        guard sender == CancelButton else { return }
        self.dismiss(sender)
    }
    
}

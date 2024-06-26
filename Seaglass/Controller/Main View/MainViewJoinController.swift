

import Cocoa
import SwiftMatrixSDK

class MainViewJoinController: NSViewController {
    @IBOutlet weak var CreateRoomButton: NSButton!
    @IBOutlet weak var CreateRoomSpinner: NSProgressIndicator!
    @IBOutlet weak var CreateRoomName: NSTextField!
    @IBOutlet weak var JoinRoomButton: NSButton!
    @IBOutlet weak var JoinRoomSpinner: NSProgressIndicator!
    @IBOutlet weak var JoinRoomText: NSTextField!
    
    var controls: [NSControl] = []

    override func viewDidLoad() {
        controls = [ CreateRoomButton, JoinRoomButton,
                     JoinRoomText, CreateRoomName ]
        for control in controls {
            control.isEnabled = true
        }
        super.viewDidLoad()
    }
    
    @IBAction func createRoomButtonClicked(_ sender: NSButton) {
        let roomNameField = self.CreateRoomName.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var roomName: String? = nil
        if roomNameField.count > 0 {
            roomName = roomNameField
        }
        for control in controls {
            control.isEnabled = false
        }
        CreateRoomSpinner.startAnimation(sender)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            CreateRoomButton.animator().alphaValue = 0
            CreateRoomSpinner.alphaValue = 1
        }, completionHandler: {
            MatrixServices.inst.session.createRoom(name: roomName, visibility: nil, alias: nil, topic: nil, preset: MXRoomPreset.publicChat, completion: { (response) in
                if response.isFailure, let error = response.error {
                    let alert = NSAlert()
                    alert.messageText = "Failed to create room"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
                sender.window?.contentViewController?.dismiss(sender)
            })
        })
    }

    @IBAction func joinRoomButtonClicked(_ sender: NSButton) {
        let room = self.JoinRoomText.stringValue
        if !(room.starts(with: "#") || room.starts(with: "!") || room.starts(with: "@")) || !room.contains(":") {
            return
        }
        for control in controls {
            control.isEnabled = false
        }
        JoinRoomSpinner.startAnimation(sender)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            JoinRoomButton.animator().alphaValue = 0
            JoinRoomSpinner.alphaValue = 1
        }, completionHandler: {
            if room.starts(with: "#") || room.starts(with: "!") {
                MatrixServices.inst.session.joinRoom(room, completion: { (response) in
                    if response.isFailure, let error = response.error {
                        let alert = NSAlert()
                        alert.messageText = "Failed to join room \(room)"
                        alert.informativeText = error.localizedDescription
                        alert.alertStyle = .warning
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                    sender.window?.contentViewController?.dismiss(sender)
                })
            } else if room.starts(with: "@") {
                MatrixServices.inst.session.createRoom(name: nil, visibility: nil, alias: nil, topic: nil, preset: MXRoomPreset.trustedPrivateChat, completion: { (response) in
                    if response.isFailure, let error = response.error {
                        let alert = NSAlert()
                        alert.messageText = "Failed to create room"
                        alert.informativeText = error.localizedDescription
                        alert.alertStyle = .warning
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                        sender.window?.contentViewController?.dismiss(sender)
                    } else {
                        if let roomId = response.value?.roomId {
                            let invitee = MXRoomInvitee.userId(room)
                            MatrixServices.inst.session.room(withRoomId: roomId).invite(invitee, completion: { (response) in
                                if response.isFailure, let error = response.error {
                                    let alert = NSAlert()
                                    alert.messageText = "Failed to invite \(room)"
                                    alert.informativeText = error.localizedDescription
                                    alert.alertStyle = .warning
                                    alert.addButton(withTitle: "OK")
                                    alert.runModal()
                                }
                                sender.window?.contentViewController?.dismiss(sender)
                            })
                        }
                    }
                })
            }
        })
    }
}



import Cocoa
import SwiftMatrixSDK

class MainViewKeyRequestController: NSViewController {

    @IBOutlet weak var UserIDField: NSTextField!
    @IBOutlet weak var DeviceNameField: NSTextField!
    @IBOutlet weak var DeviceIDField: NSTextField!
    @IBOutlet weak var DeviceKeyField: NSTextField!
    @IBOutlet weak var ConfirmationCheckbox: NSButton!
    @IBOutlet weak var ShareButton: NSButton!
    @IBOutlet weak var IgnoreButton: NSButton!
    
    var request: MXIncomingRoomKeyRequest?
    
    override func viewWillAppear() {
        guard request != nil else { return }
        
        if let storedDevice = MatrixServices.inst.session.crypto.deviceList.storedDevice(request!.userId, deviceId: request!.deviceId) {

            if let edkey = storedDevice.fingerprint {
                DeviceKeyField.stringValue = String(edkey.enumerated().map { $0 > 0 && $0 % 4 == 0 ? [" ", $1] : [$1]}.joined())
            }
            
            DeviceNameField.stringValue = storedDevice.displayName ?? ""
            
            UserIDField.stringValue = request!.userId
            DeviceIDField.stringValue = request!.deviceId
            
            ConfirmationCheckbox.state = .off
        } else {
            let alert = NSAlert()
            alert.messageText = "Incoming keyshare request failed"
            alert.informativeText = "The device information was not available."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            self.dismiss(self)
        }
    }

    @IBAction func shareButtonPressed(_ sender: NSButton) {
        guard request != nil else { return }
        guard sender == ShareButton else { return }
        guard ConfirmationCheckbox.state == .on else { return }
        
        MatrixServices.inst.session.crypto.acceptAllPendingKeyRequests(fromUser: request!.userId, andDevice: request!.deviceId) {
            MatrixServices.inst.session.crypto.setDeviceVerification(MXDeviceVerified, forDevice: self.self.request!.deviceId, ofUser: self.request!.userId, success: {
                MatrixServices.inst.mainController?.channelDelegate?.uiRoomNeedsCryptoReload()
            }, failure: { (error) in
                let alert = NSAlert()
                alert.messageText = "Failed to verify device"
                alert.informativeText = error!.localizedDescription
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            })
            self.dismiss(sender)
            MatrixServices.inst.mainController?.matrixDidCompleteKeyRequest(self.request!)
        }
    }
    
    @IBAction func ignoreButtonPressed(_ sender: NSButton) {
        guard sender == IgnoreButton else { return }
        
        MatrixServices.inst.session.crypto.ignoreAllPendingKeyRequests(fromUser: request!.userId, andDevice: request!.deviceId) {
            self.dismiss(sender)
            MatrixServices.inst.mainController?.matrixDidCompleteKeyRequest(self.request!)
        }
    }
    
    @IBAction func confirmationCheckboxPressed(_ sender: NSButton) {
        guard sender == ConfirmationCheckbox else { return }
        ShareButton.isEnabled = sender.state == .on
    }
    
}

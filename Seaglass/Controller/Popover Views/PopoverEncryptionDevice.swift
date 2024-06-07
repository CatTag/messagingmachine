

import Cocoa
import SwiftMatrixSDK

class PopoverEncryptionDevice: NSViewController {

    @IBOutlet weak var DownloadSpinner: NSProgressIndicator!
    
    @IBOutlet weak var DeviceName: NSTextField!
    @IBOutlet weak var DeviceID: NSTextField!
    @IBOutlet weak var DeviceFingerprint: NSTextField!
    
    @IBOutlet weak var MessageAlgorithm: NSTextField!
    
    @IBOutlet weak var DeviceVerified: NSButton!
    @IBOutlet weak var DeviceBlacklisted: NSButton!
    
    var event: MXEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadSpinner.isHidden = true
        
        guard event != nil else {
            DeviceVerified.isEnabled = false
            DeviceBlacklisted.isEnabled = false
            return
        }
        
        if let deviceInfo = MatrixServices.inst.session.crypto.eventDeviceInfo(self.event) {
            if MatrixServices.inst.client.credentials.deviceId == deviceInfo.deviceId {
                MatrixServices.inst.client.device(withId: MatrixServices.inst.client.credentials.deviceId, completion: { (response) in
                    if response.isSuccess {
                        if let device = response.value {
                            self.DeviceName.stringValue = device.displayName ?? ""
                            self.DeviceID.stringValue = device.deviceId ?? ""
                        }
                    }
                })
            } else {
                DeviceName.stringValue = deviceInfo.displayName ?? ""
                DeviceID.stringValue = deviceInfo.deviceId ?? ""
            }
    
            DeviceFingerprint.stringValue = String(deviceInfo.fingerprint.enumerated().map { $0 > 0 && $0 % 4 == 0 ? [" ", $1] : [$1]}.joined())
            
            if deviceInfo.userId == MatrixServices.inst.session.myUser.userId {
                DeviceVerified.isEnabled = deviceInfo.deviceId != MatrixServices.inst.client.credentials.deviceId
                DeviceBlacklisted.isEnabled = DeviceVerified.isEnabled
            }

            DeviceVerified.state = deviceInfo.verified == MXDeviceVerified ? .on : .off
            DeviceBlacklisted.state = deviceInfo.verified == MXDeviceBlocked ? .on : .off
        } else {
            DeviceVerified.isEnabled = false
            DeviceBlacklisted.isEnabled = false
            
            DownloadSpinner.isHidden = false
            DownloadSpinner.startAnimation(self)
            
            MatrixServices.inst.session.crypto.downloadKeys([event!.sender], forceDownload: false, success: { (devicemap) in
                self.DownloadSpinner.stopAnimation(self)
                self.DownloadSpinner.isHidden = true

                if MatrixServices.inst.session.crypto.eventDeviceInfo(self.event) != nil {
                    self.viewDidLoad()
                }
            }) { (error) in
                OperationQueue.main.addOperation {
                    self.DownloadSpinner.stopAnimation(self)
                    self.DownloadSpinner.isHidden = true
                }
            }
        }
        
        MessageAlgorithm.stringValue = event!.wireContent["algorithm"] as? String ?? ""
    }
    
    @IBAction func deviceVerificationChanged(_ sender: NSButton) {
        guard sender == DeviceVerified || sender == DeviceBlacklisted else { return }
        guard event != nil else { return }
        
        if let deviceInfo = MatrixServices.inst.session.crypto.eventSenderDevice(of: event) {
            if sender == DeviceVerified {
                if DeviceVerified.state == .on {
                    DeviceBlacklisted.state = .off
                }
            }
            
            if sender == DeviceBlacklisted {
                if DeviceBlacklisted.state == .on {
                    DeviceVerified.state = .off
                }
            }
            
            let verificationState =
                DeviceBlacklisted.state == .on ? MXDeviceBlocked :
                DeviceVerified.state == .on ? MXDeviceVerified : MXDeviceUnverified
            
            DeviceVerified.isEnabled = false
            DeviceBlacklisted.isEnabled = false
        
            MatrixServices.inst.session.crypto.setDeviceVerification(verificationState, forDevice: deviceInfo.deviceId, ofUser: deviceInfo.userId, success: {
                self.DeviceVerified.isEnabled = true
                self.DeviceBlacklisted.isEnabled = true
                
                MatrixServices.inst.mainController?.channelDelegate?.uiRoomNeedsCryptoReload()
            }) { (error) in
                self.DeviceVerified.state = deviceInfo.verified == MXDeviceVerified ? .on : .off
                self.DeviceBlacklisted.state = deviceInfo.verified == MXDeviceBlocked ? .on : .off
                
                self.DeviceVerified.isEnabled = true
                self.DeviceBlacklisted.isEnabled = true
            }
        }
    }
    
}

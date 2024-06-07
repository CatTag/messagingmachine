

import Cocoa
import SwiftMatrixSDK

class MainViewSendErrorController: NSViewController {
    @IBOutlet var ApplyAllCheckbox: NSButton!
    @IBOutlet var ErrorDescription: NSTextField!
    
    public var roomId: String?
    public var eventId: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ignoreButtonClicked(_ sender: NSButton) {
        self.dismiss(sender)
    }
    
    @IBAction func deleteButtonClicked(_ sender: NSButton) {
        if let room = MatrixServices.inst.session.room(withRoomId: roomId) {
            // TODO: FIX THIS
          /*  if ApplyAllCheckbox.state == .off {
                if let index = (self.mainController?.channelDelegate?.roomCache.content as! [MXEvent]).index(where: { $0.eventId == eventId }) {
                    self.mainController?.channelDelegate?.roomCache.remove(atArrangedObjectIndex: index)
                }

            } else {
                for (index, event) in MatrixServices.inst.eventCache[roomId!]!.enumerated() {
                    if event.sentState == MXEventSentStateFailed {
                        let event = MatrixServices.inst.eventCache[roomId!]![index]
                        MatrixServices.inst.mainController?.channelDelegate?.matrixDidRoomMessage(event: event.prune(), direction: .forwards, roomState: room.state, replaces: eventId, removeOnReplace: true)
                        MatrixServices.inst.eventCache[roomId!]![index] = event.prune()
                    }
                }
            } */
        }
        self.dismiss(sender)
    }
    
    @IBAction func sendAgainButtonClicked(_ sender: NSButton) {
        self.dismiss(sender)
    }
}

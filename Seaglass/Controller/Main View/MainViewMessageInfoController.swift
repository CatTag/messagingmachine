

import Cocoa
import SwiftMatrixSDK

class MainViewMessageInfoController: NSViewController {
    
    @IBOutlet var EventSourceView: NSTextView!
    @IBOutlet weak var EventTimestamp: NSTextField!
    
    var event: MXEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard event != nil else { return }
        
        let eventTime = Date(timeIntervalSince1970: TimeInterval(event!.originServerTs / 1000))
        let eventTimeFormatter = DateFormatter()
        eventTimeFormatter.timeZone = TimeZone.current
        eventTimeFormatter.timeStyle = .long
        eventTimeFormatter.dateStyle = .long
        
        EventTimestamp.stringValue = eventTimeFormatter.string(from: eventTime)
        do {
            let str = NSString(data: try JSONSerialization.data(withJSONObject: event!.jsonDictionary(), options: JSONSerialization.WritingOptions.prettyPrinted), encoding: String.Encoding.utf8.rawValue)! as String
            EventSourceView.string = str.replacingOccurrences(of: "\\/", with: "/")
        } catch {
            EventSourceView.string = "Exception caught"
        }
    }
    
}

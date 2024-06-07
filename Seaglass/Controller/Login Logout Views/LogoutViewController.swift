
import Cocoa

class LogoutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MatrixServices.inst.logout()
    }
    
}

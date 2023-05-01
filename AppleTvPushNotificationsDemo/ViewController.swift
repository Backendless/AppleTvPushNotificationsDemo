
import UIKit
import Backendless

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedPush(_ sender: Any) {
        let publishOptions = PublishOptions()
        publishOptions.headers = ["ios-sound": "",
                                  "ios-content-available": 1,
                                  "myMessage": "THIS IS MY SILENT TEST MESSAGE"]
        
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.publishAt = Date(timeIntervalSinceNow: 10)
        deliveryOptions.publishPolicy = PublishPolicyEnum.PUSH.rawValue
        
        Backendless.shared.messaging.publish(channelName: "default", message: "", publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: { status in
            let alert = UIAlertController(title: "Notification sent", message: "Message has been pushed. Wait for it in 10 seconds", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, errorHandler: { fault in
            let alert = UIAlertController(title: "Error", message: fault.message ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}


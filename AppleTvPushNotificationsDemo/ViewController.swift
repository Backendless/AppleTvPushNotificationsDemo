
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedPush(_ sender: Any) {
        let publishOptions = PublishOptions()
        publishOptions.assignHeaders(["ios-sound":""])
        publishOptions.addHeader("ios-content-available", value: 1)
        publishOptions.addHeader("myMessage", value: "THIS IS MY SILENT TEST MESSAGE")
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.publishAt = Date(timeIntervalSinceNow: 10)
        deliveryOptions.publishPolicy(PUSH.rawValue)
        Backendless.sharedInstance().messaging.publish("default", message: "", publishOptions: publishOptions, deliveryOptions: deliveryOptions, response: { status in
            let alert = UIAlertController(title: "Notification sent", message: "Message has been pushed. Wait for it in 10 seconds", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, error: { fault in
            let alert = UIAlertController(title: "Error", message: fault?.detail, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}



import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    let APPLICATION_ID = "APP_ID"
    let API_KEY = "API_KEY"
    let SERVER_URL = "https://api.backendless.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {    
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge]) { (granted, error) in
            application.registerForRemoteNotifications()
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Backendless.sharedInstance().messaging.registerDevice(deviceToken, channels: ["default"], response: { result in
            let alert = UIAlertController(title: "Registration complete", message: "Apple TV registered with id: \(Backendless.sharedInstance().messaging.currentDevice().deviceId)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }, error: { fault in
            let alert = UIAlertController(title: "Error", message: fault?.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let receivedMessage = userInfo["myMessage"] as? String {
            let alert = UIAlertController(title: "Silent notification received", message: receivedMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
        completionHandler(.newData);
    }
}


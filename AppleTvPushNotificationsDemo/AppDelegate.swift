
import UIKit
import UserNotifications
import Backendless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    let APPLICATION_ID = "APP_ID"
    let API_KEY = "API_KEY"
    let SERVER_URL = "https://eu-api.backendless.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initBackendless()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge]) { (granted, error) in
            application.registerForRemoteNotifications()
        }
        return true
    }
    
    private func initBackendless() {
        Backendless.shared.hostUrl = SERVER_URL
        Backendless.shared.initApp(applicationId: APPLICATION_ID, apiKey: API_KEY)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Backendless.shared.messaging.registerDevice(deviceToken: deviceToken, channels: ["default"], responseHandler: { result in
            let alert = UIAlertController(title: "Registration complete", message: "Apple TV registered with id: \(Backendless.shared.messaging.currentDevice().deviceId ?? "N/A")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }, errorHandler: { fault in
            let alert = UIAlertController(title: "Error", message: fault.message, preferredStyle: .alert)
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


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = ViewController()
        rootViewController.view.backgroundColor = UIColor.white
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        return true
    }
}

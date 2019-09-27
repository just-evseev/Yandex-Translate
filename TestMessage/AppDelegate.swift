import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = ViewController()
        let presenter = ViewPresenter()
        presenter.view = rootViewController
        rootViewController.presenter = presenter
        rootViewController.view.backgroundColor = UIColor.white
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        return true
    }
}

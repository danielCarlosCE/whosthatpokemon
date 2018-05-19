import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator = AppCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupRootViewController()

        return true
    }

    private func setupRootViewController() {
        window = UIWindow()
        window?.rootViewController = appCoordinator.viewController
        window?.makeKeyAndVisible()
    }

}

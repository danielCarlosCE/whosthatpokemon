import UIKit
import Rswift

protocol Coordinator {
    var viewController: UIViewController { get }
}

class AppCoordinator: Coordinator {
    let viewController: UIViewController

    init() {
        guard let pokemonslistViewController = R.storyboard.main.pokemonsList() else { fatalError("Rswift wasn't able to find pokemonsList at \(#function)") }
        viewController = pokemonslistViewController
    }
}

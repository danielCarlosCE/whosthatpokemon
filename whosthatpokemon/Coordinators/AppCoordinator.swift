import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }
}

class AppCoordinator: Coordinator {
    let viewController: UIViewController

    init() {
        let tabbar = UITabBarController()
        viewController = tabbar

        let listNavigation = pokemonsListNavigation(service: PokemonService())

        let favorites = pokemonsListNavigation(service: FavoritesPokemonsService())
        favorites.tabBarItem =
            UITabBarItem(title: "My pokemons", image: R.image.pokeball(), selectedImage: nil)

        tabbar.viewControllers = [listNavigation, favorites]

    }

    func pokemonsListNavigation(service: PokemonServiceType) -> UINavigationController {
        guard let pokemonslistViewController = R.storyboard.main.pokemonsList() else {
            fatalError("Rswift wasn't able to find pokemonsList at \(#function)")
        }

        pokemonslistViewController.viewModel = PokemonsListViewModel(service: service)

        let listNavigation = UINavigationController(rootViewController: pokemonslistViewController)
        listNavigation.tabBarItem =
            UITabBarItem(title: "Catcha them all", image: R.image.backpack(), selectedImage: nil)
        listNavigation.setNavigationBarHidden(true, animated: false)

        return listNavigation
    }
}

import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }
}

class AppCoordinator: Coordinator {
    let tabbar = UITabBarController()
    var viewController: UIViewController { return tabbar }
    let dependenciesResolver = AppDependenciesResolver()

    init() {

        let listNavigation = pokemonsListNavigation(service: dependenciesResolver.pokemonsService)

        let favorites = pokemonsListNavigation(service: dependenciesResolver.favoritesPokemonsServirce)
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
        pokemonslistViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        pokemonslistViewController.didAppear  = { [weak listNavigation] in
            listNavigation?.setNavigationBarHidden(true, animated: false)
        }
        pokemonslistViewController.didSelectItem = {[weak self] pokemon in
            self?.navigateToDetails(from: listNavigation, with: pokemon)
        }

        return listNavigation
    }
}

extension AppCoordinator {
    func navigateToDetails(from navigation: UINavigationController, with pokemonPayload: PokemonPayload) {
        guard let detailsViewController = R.storyboard.main.pokemonDetails() else {
            fatalError("Rswift wasn't able to find pokemonDetails at \(#function)")
        }

        let service = dependenciesResolver.pokemonDetailsService
        detailsViewController.viewModel = PokemonDetailsViewModel(pokemonPayload: pokemonPayload, service: service)
        navigation.pushViewController(detailsViewController, animated: true)
        navigation.setNavigationBarHidden(false, animated: true)
    }
}

import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }
}

class AppCoordinator: Coordinator {
    let tabbar = UITabBarController()
    var viewController: UIViewController { return tabbar }
    let dependenciesResolver = AppDependenciesResolver()
    var favoritesService: FavoritesPokemonsServiceType { return dependenciesResolver.favoritesPokemonsServirce }

    init() {

        let listNavigation = pokemonsListNavigation(service: dependenciesResolver.pokemonsService, path: .all)
        listNavigation.tabBarItem =
            UITabBarItem(title: "Catcha them all", image: R.image.backpack(), selectedImage: nil)
        listNavigation.view.accessibilityIdentifier = "List.View"

        let favorites = pokemonsListNavigation(service: favoritesService, path: .favorites)
        favorites.tabBarItem =
            UITabBarItem(title: "My pokemons", image: R.image.pokeball(), selectedImage: nil)
        favorites.view.accessibilityIdentifier = "Favorites.View"

        tabbar.viewControllers = [listNavigation, favorites]

    }

    func pokemonsListNavigation(service: PokemonServiceType, path: Path) -> UINavigationController {
        guard let pokemonslistViewController = R.storyboard.main.pokemonsList() else {
            fatalError("Rswift wasn't able to find pokemonsList at \(#function)")
        }

        pokemonslistViewController.viewModel = PokemonsListViewModel(service: service)

        let listNavigation = UINavigationController(rootViewController: pokemonslistViewController)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        pokemonslistViewController.navigationItem.backBarButtonItem = backButton

        setupEvents(pokemonslistViewController, listNavigation, path)

        return listNavigation
    }

    fileprivate func setupEvents(_ list: PokemonsListViewController,
                                 _ nav: UINavigationController, _ path: AppCoordinator.Path) {
        list.willAppear  = {
            nav.setNavigationBarHidden(true, animated: false)

            if case .favorites = path {
                list.viewDidLoad()
            }

        }
        list.didSelectItem = {[weak self] pokemon in
            self?.navigateToDetails(from: nav, with: pokemon, path: path)
        }
    }

    enum Path {
        case all
        case favorites
    }
}

extension AppCoordinator {
    func navigateToDetails(from navigation: UINavigationController, with pokemonPayload: PokemonPayload, path: Path) {
        guard let detailsViewController = R.storyboard.main.pokemonDetails() else {
            fatalError("Rswift wasn't able to find pokemonDetails at \(#function)")
        }

        let service = dependenciesResolver.pokemonDetailsService
        detailsViewController.viewModel = PokemonDetailsViewModel(pokemonPayload: pokemonPayload, service: service)
        navigation.pushViewController(detailsViewController, animated: true)
        navigation.setNavigationBarHidden(false, animated: false)

        setupEvents(detailsViewController, navigation, path)
    }

    fileprivate func setupEvents(_ details: PokemonDetailsViewController,
                                 _ nav: UINavigationController, _ path: AppCoordinator.Path) {
        details.didSelectItem = { [weak self] pokemon in
            switch path {
            case .all:
                self?.favoritesService.save(pokemon: pokemon)
                nav.popViewController(animated: false)
                self?.tabbar.selectedIndex = 1
            case .favorites:
                self?.favoritesService.delete(pokemon: pokemon)
                nav.popViewController(animated: true)
            }
        }
    }
}

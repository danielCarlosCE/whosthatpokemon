struct AppDependenciesResolver {
    var pokemonsService: PokemonServiceType {
        return PokemonService()
    }
    var favoritesPokemonsServirce: FavoritesPokemonsServiceType {
        return FavoritesPokemonsService(storageManger: storageManager)
    }
    var pokemonDetailsService: PokemonDetailsServiceType {
        return PokemonDetailsService()
    }
    var storageManager: PokemonsStorageManagerType {
        return PokemonsStorageManager.shared
    }
}

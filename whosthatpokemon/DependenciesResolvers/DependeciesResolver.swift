struct AppDependenciesResolver {
    var pokemonsService: PokemonServiceType {
        return PokemonService()
    }
    var favoritesPokemonsServirce: PokemonServiceType {
        return FavoritesPokemonsService(storageManger: storageManager)
    }
    var storageManager: PokemonsStorageManagerType {
        return PokemonsStorageManager.shared
    }
}

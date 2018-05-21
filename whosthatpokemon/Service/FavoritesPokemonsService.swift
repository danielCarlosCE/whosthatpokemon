import Foundation

protocol FavoritesPokemonsServiceType: PokemonServiceType {
    func save(pokemon: Pokemon)
    func delete(pokemon: Pokemon)
}

class FavoritesPokemonsService: BaseService, FavoritesPokemonsServiceType {

    let storageManager: PokemonsStorageManagerType

    init(storageManger: PokemonsStorageManagerType) {
        self.storageManager = storageManger
    }

    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void) {
        completion(.success(storageManager.fetchAll()))
    }

    func fetchImage(id: Int, completion: @escaping (FetchImageResult) -> Void) {
        let frontDefault = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        let backDefault = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/\(id).png"
        let frontShiny = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png"
        let backShiny = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/\(id).png"

        var images = [Data]()
        let dispatchGroup = DispatchGroup()

        [frontDefault, backDefault, backShiny, frontShiny].forEach {

            dispatchGroup.enter()

            guard let url = URL(string: $0) else { fatalError("Bad URL \(#function)") }
            rawFetchIgnoringError(url: url) { (data) in
                if let data = data { images.append(data) }
                dispatchGroup.leave()
            }

        }

        dispatchGroup.notify(queue: DispatchQueue(label: "downloaded"), work: DispatchWorkItem {
            completion(.multiple(images))
        })
    }

}

extension FavoritesPokemonsService {
    func save(pokemon: Pokemon) {
        storageManager.save(pokemon: pokemon)
    }

    func delete(pokemon: Pokemon) {
        storageManager.delete(pokemon: pokemon)
    }
}

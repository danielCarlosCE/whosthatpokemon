import Foundation

protocol FavoritesPokemonsServiceType: PokemonServiceType {

}

class FavoritesPokemonsService: BaseService, FavoritesPokemonsServiceType {

    let storageManager: PokemonsStorageManagerType

    init(storageManger: PokemonsStorageManagerType) {
        self.storageManager = storageManger
    }

    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void) {
        seed()
        completion(.success(storageManager.fetchAll()))
    }

    private func seed() {
        [Pokemon(id: 1, name: "bulbasaur"),
         Pokemon(id: 4, name: "charmander"),
         Pokemon(id: 7, name: "squirtle"),
         Pokemon(id: 25, name: "pikachu")].forEach {
            PokemonsStorageManager.shared.save(pokemon: $0)
        }
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

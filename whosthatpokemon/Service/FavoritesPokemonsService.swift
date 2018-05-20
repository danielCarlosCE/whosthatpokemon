import Foundation

protocol FavoritesPokemonsServiceType: PokemonServiceType {

}

class FavoritesPokemonsService: FavoritesPokemonsServiceType {
    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void) {
        completion(.success(
            [Pokemon(id: 1, name: "bulbasaur"),
            Pokemon(id: 4, name: "charmander"),
            Pokemon(id: 7, name: "squirtle"),
            Pokemon(id: 25, name: "pikachu")]
        ))
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
            URLSession.shared.dataTask(with: URL(string: $0)!) { data, _, _ in
                if let data = data { images.append(data) }
                dispatchGroup.leave()
            }.resume()

        }

        dispatchGroup.notify(queue: DispatchQueue(label: "downloaded"), work: DispatchWorkItem {
            completion(.multiple(images))
        })
    }

}

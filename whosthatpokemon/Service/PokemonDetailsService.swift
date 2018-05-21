import Foundation

protocol PokemonDetailsServiceType {
    func fetchDetail(for: Pokemon, completion: @escaping (Result<PokemonDetails>) -> Void)
}

class PokemonDetailsService: BaseService, PokemonDetailsServiceType {
    func fetchDetail(for pokemon: Pokemon, completion: @escaping (Result<PokemonDetails>) -> Void) {
        let url = baseUrl.appendingPathComponent("pokemon-species/\(pokemon.id)")

        fetch(url: url) { (result) in
            completion(result)
        }
    }

}

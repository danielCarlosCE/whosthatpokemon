import Foundation

protocol PokemonServiceType {
    func fetchFirstGeneration(completion: @escaping (Result<[Pokemon]>) -> Void)
    func fetchImage(id: Int, completion: @escaping (Data) -> Void)
}

class PokemonService: PokemonServiceType {
    func fetchFirstGeneration(completion: @escaping (Result<[Pokemon]>) -> Void) {
        guard let api = URL(string: "http://pokeapi.co/api/v2/generation/1") else { fatalError("Bad URL \(#function)") }

        URLSession.shared.dataTask(with: api) { (data, _, error) in
            guard let data = data else {
                completion(.failure(Error(error)))
                return
            }

            guard let response = try? JSONDecoder().decode(FetchResponse.self, from: data) else {
                completion(.failure(.unknow))
                return
            }

            completion(.success(response.species))

        }.resume()
    }

    func fetchImage(id: Int, completion: @escaping (Data) -> Void) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, _ in
            if let data = data { completion(data) }
        }.resume()
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum Error {
    case known(Swift.Error)
    case unknow

    init(_ error: Swift.Error?) {
        guard let error = error else {
            self = .unknow
            return
        }

        self = .known(error)
    }
}

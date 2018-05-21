import Foundation

protocol PokemonServiceType {
    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void)
    func fetchImage(id: Int, completion: @escaping (FetchImageResult) -> Void)
}

class PokemonService: BaseService, PokemonServiceType {
    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void) {
        let url = baseUrl.appendingPathComponent("generation/1")

        fetch(url: url) { (result: Result<FetchResponse>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response.species))
            }
        }
    }

    func fetchImage(id: Int, completion: @escaping (FetchImageResult) -> Void) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        guard let url = URL(string: urlString) else { fatalError("Bad URL \(#function)") }

        rawFetchIgnoringError(url: url) { (data) in
            if let data = data { completion(.single(data)) }
        }

    }
}

enum FetchImageResult {
    case single(Data)
    case multiple([Data])
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

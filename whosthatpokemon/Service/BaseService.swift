import Foundation

class BaseService {
    let baseUrl: URL

    init() {
        guard let baseUrl = URL(string: "http://pokeapi.co/api/v2/") else { fatalError("Bad URL \(#function)") }
        self.baseUrl = baseUrl
    }

    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                completion(.failure(Error(error)))
                return
            }

            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.unknow))
                return
            }

            completion(.success(response))

        }.resume()
    }

    func rawFetchIgnoringError(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }

}

enum Result<T> {
    case success(T)
    case failure(Error)
}

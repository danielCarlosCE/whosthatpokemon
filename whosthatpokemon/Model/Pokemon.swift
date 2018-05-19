struct Pokemon {
    let id: Int
    let name: String
}

extension Pokemon: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        let url = try container.decode(String.self, forKey: .url)

        guard let value = url.split(separator: "/").last, let id = Int(String(describing: value)) else {
            fatalError("Unable to determine id. \(#function)")
        }

        self.id = id
    }
}

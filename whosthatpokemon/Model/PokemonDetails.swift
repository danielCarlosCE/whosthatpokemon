import Foundation

struct PokemonDetails {
    var pokemon: Pokemon
    var description: String
    var color: Color
    var image: Data?

}

extension PokemonDetails: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptions = "flavor_text_entries"
        case color = "color"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int.self, forKey: .id)
        let descriptions = try container.decode([Description].self, forKey: .descriptions)
        let color = try container.decode(Color.self, forKey: .color)

        self.pokemon = Pokemon(id: id, name: name)
        guard let description = (descriptions.filter { $0.language.name == "en" }.first?.description) else {
            throw NSError()
        }
        self.description = description
        self.color = color
    }
}

private struct Description: Codable {
    var description: String
    var language: Language
    private enum CodingKeys: String, CodingKey {
        case description = "flavor_text"
        case language
    }
}

private struct Language: Codable {
    var name: String
}

extension PokemonDetails {
    enum Color: String, Decodable {
        case black
        case blue
        case brown
        case gray
        case green
        case pink
        case purple
        case red
        case white
        case yellow

        private enum CodingKeys: String, CodingKey {
            case name
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .name)
            guard let color = Color(rawValue: name) else { throw NSError() }

            self = color
        }
    }
}

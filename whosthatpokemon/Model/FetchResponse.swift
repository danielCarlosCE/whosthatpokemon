struct FetchResponse: Decodable {
    let species: [Pokemon]
    private enum CodingKeys: String, CodingKey {
        case species = "pokemon_species"
    }
}

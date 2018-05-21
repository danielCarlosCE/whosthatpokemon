import Foundation

protocol PokemonDetailsViewModelType {
    var input: PokemonDetailsViewModelInput { get }
    var output: PokemonDetailsViewModelOutput { get }
}

class PokemonDetailsViewModel: PokemonDetailsViewModelType {
    private(set) var input = PokemonDetailsViewModelInput()
    private(set) var output = PokemonDetailsViewModelOutput()

    private let pokemonPayload: PokemonPayload
    private let service: PokemonDetailsServiceType

    private var pokemonDetailsObserver: ( (PokemonDetailsViewModelOutput.Result) -> Void )?

    init(pokemonPayload: PokemonPayload, service: PokemonDetailsServiceType) {
        self.pokemonPayload = pokemonPayload
        self.service = service
        input.delegate = self
        output.delegate = self
    }
}

struct PokemonPayload {
    var pokemon: Pokemon
    var image: Data?
}

extension PokemonDetailsViewModel: PokemonDetailsViewModelInputDelegate {
    func load() {
        pokemonDetailsObserver?(.loading(pokemonPayload))
        service.fetchDetail(for: pokemonPayload.pokemon) { [weak self] (result) in
            switch result {
            case .success(var pokemonDetail):
                pokemonDetail.description = pokemonDetail.description.replacingOccurrences(of: "\n", with: " ")
                pokemonDetail.image = self?.pokemonPayload.image
                self?.pokemonDetailsObserver?(.loaded(pokemonDetail))
            default:
                break
            }
        }
    }
}

extension PokemonDetailsViewModel: PokemonDetailsViewModelOutputDelegate {
    func addPokemonDetailsObserver(_ observer: @escaping (PokemonDetailsViewModelOutput.Result) -> Void) {
        self.pokemonDetailsObserver = observer
    }
}

class PokemonDetailsViewModelInput {
    fileprivate weak var delegate: PokemonDetailsViewModelInputDelegate?

    func load() {
        delegate?.load()
    }
}

private protocol PokemonDetailsViewModelInputDelegate: class {
    func load()
}

class PokemonDetailsViewModelOutput {
    fileprivate weak var delegate: PokemonDetailsViewModelOutputDelegate?

    func observePokemonDetails( _ observer: @escaping (PokemonDetailsViewModelOutput.Result) -> Void) {
        delegate?.addPokemonDetailsObserver(observer)
    }

    enum Result {
        case loading(PokemonPayload)
        case loaded(PokemonDetails)
    }
}

private protocol PokemonDetailsViewModelOutputDelegate: class {
    func addPokemonDetailsObserver(_ observer: @escaping (PokemonDetailsViewModelOutput.Result) -> Void)
}

import Foundation

protocol PokemonsListViewModelType {
    var input: PokemonsListViewModelInput { get }
    var output: PokemonsListViewModelOutPut { get }
}

class PokemonsListViewModel: PokemonsListViewModelType {

    var input = PokemonsListViewModelInput()
    var output = PokemonsListViewModelOutPut()

    private let service: PokemonServiceType
    private var pokemons: [Pokemon] = []
    private var pokemonObserver: ( (PokemonsListViewModelOutPut.Result) -> Void )?

    init(service: PokemonServiceType) {
        self.service = service
        self.input.delegate = self
        self.output.delegate = self
    }

}

extension PokemonsListViewModel: PokemonsListViewModelInputDelegate {
    fileprivate func load() {
        pokemonObserver?(.loading)
        service.fetchFirstGeneration { [weak self] (result) in
            switch result {
            case .success(let pokemons):
                let sorted = pokemons.sorted { $0.id < $1.id }
                self?.pokemonObserver?(.loaded(sorted))
            default: break
            }

        }

    }

    fileprivate func downloadImage(for id: Int, completion: @escaping (Data) -> Void) {
        service.fetchImage(id: id, completion: completion)
    }
}

extension PokemonsListViewModel: PokemonsListViewModelOutPutDelegate {
    fileprivate func addPokemonObserver(_ observer: @escaping (PokemonsListViewModelOutPut.Result) -> Void) {
        self.pokemonObserver = observer
        if pokemons.isEmpty {
            observer(.loading)
        }
    }
}

// MARK: Input
class PokemonsListViewModelInput {
    fileprivate weak var delegate: PokemonsListViewModelInputDelegate?
    fileprivate init() { }

    func load() {
        delegate?.load()
    }

    func downloadImage(for id: Int, completion: @escaping (Data) -> Void) {
        delegate?.downloadImage(for: id, completion: completion)
    }

}

private protocol PokemonsListViewModelInputDelegate: class {
    func load()
    func downloadImage(for id: Int, completion: @escaping (Data) -> Void)
}

// MARK: Output
class PokemonsListViewModelOutPut {
    fileprivate weak var delegate: PokemonsListViewModelOutPutDelegate?
    fileprivate init() { }

    func observePokemons( _ observer: @escaping (Result) -> Void) {
        delegate?.addPokemonObserver(observer)
    }

    enum Result {
        case loading
        case loaded([Pokemon])
    }
}

private protocol PokemonsListViewModelOutPutDelegate: class {
    func addPokemonObserver(_ observer: @escaping (PokemonsListViewModelOutPut.Result) -> Void)
}
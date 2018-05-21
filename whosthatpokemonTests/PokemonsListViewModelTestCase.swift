import XCTest
@testable import whosthatpokemon

class PokemonsListViewModelTestCase: XCTestCase {

    private var sut: PokemonsListViewModel!
    private var service: MockService!

    override func setUp() {
        service = MockService()
        sut = PokemonsListViewModel(service: service)
    }

    func testInputDoesLoadOutput() {
        var pokemons = [Pokemon]()
        //given
        sut.output.observePokemons { pokemons = $0.pokemons }
        //when
        sut.input.load()
        service.returnFetchAll()
        //then
        XCTAssertFalse(pokemons.isEmpty)
    }

    func testOutputDoesSortServiceResult() {
        var pokemons = [Pokemon]()
        //given
        sut.output.observePokemons { pokemons = $0.pokemons }
        //when
        sut.input.load()
        service.returnFetchAll()
        //then
        XCTAssertEqual(pokemons, [Pokemon(id: 1, name: "Pikachu"), Pokemon(id: 2, name: "Charmander")])
    }

    func testLoadDoesNotifyLoadingBeforeFetch() {
        //given
        var result: PokemonsListViewModelOutPut.Result!
        sut.output.observePokemons {
            result = $0
        }
        //when
        sut.input.load()
        XCTAssertNotNil(result)
        //then
        XCTAssertEqual(result, PokemonsListViewModelOutPut.Result.loading)
        //when
        service.returnFetchAll()
        //then
        XCTAssertEqual(result, PokemonsListViewModelOutPut.Result.loaded([]))
    }

    func testDownloadImageDoesCallDelegateToService() {
        //when
        sut.input.downloadImage(for: 1) { _ in }

        //then
        XCTAssertTrue(service.didCallDownloadImage)
    }

}

class MockService: PokemonServiceType {
    private var completion: ( (Result<[Pokemon]>) -> Void )?

    func returnFetchAll() {
        let mockPokemons = [Pokemon(id: 2, name: "Charmander"), Pokemon(id: 1, name: "Pikachu")]
        completion?(.success(mockPokemons))
    }
    var didCallDownloadImage = false

    func fetchAll(completion: @escaping (Result<[Pokemon]>) -> Void) {
        self.completion = completion
    }
    func fetchImage(id: Int, completion: @escaping (FetchImageResult) -> Void) {
        didCallDownloadImage = true
    }
}

extension Pokemon: Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PokemonsListViewModelOutPut.Result: Equatable {
    public static func == (lhs: PokemonsListViewModelOutPut.Result, rhs: PokemonsListViewModelOutPut.Result) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.loaded, .loaded): return true
        default: return false
        }
    }

}

extension PokemonsListViewModelOutPut.Result {
    var pokemons: [Pokemon] {
        if case let .loaded(pokemons) = self {
            return  pokemons
        }
        return []
    }
}

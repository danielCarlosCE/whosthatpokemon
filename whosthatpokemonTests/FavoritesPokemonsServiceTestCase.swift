import XCTest
@testable import whosthatpokemon

class FavoritesPokemonsServiceTestCase: XCTestCase {

    var sut: FavoritesPokemonsService!
    var storageManager: MockStorage!

    override func setUp() {
        storageManager = MockStorage()
        sut = FavoritesPokemonsService(storageManger: storageManager)
    }

    func testFetchAllDoesReturnStorageFetched() {
        //given
        var pokemons: [Pokemon] = []
        sut.fetchAll { pokemons = $0.success ?? [] }

        XCTAssertEqual(pokemons, [Pokemon(id: 1, name: "bulbasaur"), Pokemon(id: 25, name: "pikachu")])
    }

    func testSaveDoesCallStorage() {
        sut.save(pokemon: Pokemon(id: 1, name: "bulbasaur"))

        XCTAssert(storageManager.didCallSave)
    }

    func testDeleteDoesCallStorage() {
        sut.delete(pokemon: Pokemon(id: 1, name: "bulbasaur"))

        XCTAssert(storageManager.didCallDelete)
    }

}

class MockStorage: PokemonsStorageManagerType {
    var didCallFetchAll = false
    var didCallSave = false
    var didCallDelete = false

    func fetchAll() -> [Pokemon] {
        didCallFetchAll = true
        return [Pokemon(id: 1, name: "bulbasaur"), Pokemon(id: 25, name: "pikachu")]
    }

    func save(pokemon: Pokemon) {
        didCallSave = true
    }

    func delete(pokemon: Pokemon) {
        didCallDelete = true
    }
}

extension Result {
    var success: T? {
        guard case let .success(t) = self else { return nil }
        return t
    }
}

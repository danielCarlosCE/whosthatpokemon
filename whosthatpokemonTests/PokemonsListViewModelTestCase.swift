//
//  PokemonsListViewModelTestCase.swift
//  whosthatpokemonTests
//
//  Created by HE:labs on 18/05/18.
//  Copyright © 2018 danielcarlosce. All rights reserved.
//

import XCTest
@testable import whosthatpokemon

class PokemonsListViewModelTestCase: XCTestCase {

    private var sut: PokemonsListViewModel!
    private var service: MockService!

    override func setUp() {
        service = MockService()
        sut = PokemonsListViewModel(service: service)
    }

    func testInputLoadsOutput() {
        var pokemons = [Pokemon]()
        //given
        sut.output.observePokemons { pokemons = $0.pokemons }
        //when
        sut.input.load()
        //then
        XCTAssertFalse(pokemons.isEmpty)
    }

    func testOutputSortsServiceResult() {
        var pokemons = [Pokemon]()
        //given
        sut.output.observePokemons { pokemons = $0.pokemons }
        //when
        sut.input.load()
        //then
        XCTAssertEqual(pokemons, [Pokemon(id: 1, name: "Pikachu"), Pokemon(id: 2, name: "Charmander")])
    }

    class MockService: PokemonServiceType {
        func fetchFirstGeneration(completion: @escaping (Result<[Pokemon]>) -> Void) {
            let mockPokemons = [Pokemon(id: 2, name: "Charmander"), Pokemon(id: 1, name: "Pikachu")]
            completion(.success(mockPokemons))
        }
        func fetchImage(id: Int, completion: @escaping (Data) -> Void) { }
    }
}

extension Pokemon: Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
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

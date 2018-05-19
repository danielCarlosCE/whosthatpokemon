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

    var sut: PokemonsListViewModel!

    override func setUp() {
        sut = PokemonsListViewModel()
    }

    func testInputLoadsOutput() {
        let expect = expectation(description: "loads")

        //given
        sut.output.observePokemons { (pokemons) in

            //then
            expect.fulfill()
            XCTAssertFalse(pokemons.isEmpty)
        }
        //when
        sut.input.load()

        waitForExpectations(timeout: 4)
    }
}

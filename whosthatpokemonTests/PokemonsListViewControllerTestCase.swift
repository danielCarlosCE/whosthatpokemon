import XCTest
@testable import whosthatpokemon

class PokemonsListViewControllerTestCase: XCTestCase {

    var sut: PokemonsListViewController!
    var viewModel: MockViewModel!
    var input: MockInput!
    var output: MockOutput!

    override func setUp() {
        input = MockInput()
        output = MockOutput()
        viewModel = MockViewModel(input: input, output: output)
        sut = R.storyboard.main.pokemonsList()!
        sut.viewModel = viewModel
    }

    func testBindsOutpuBeforeInput() {
        //given
        input.didCallLoad = {
            //then
            XCTAssertNotNil(self.output.observer)
        }

        //when
        sut.loadViewIfNeeded()
    }

    class MockViewModel: PokemonsListViewModelType {
        var input: PokemonsListViewModelInput
        var output: PokemonsListViewModelOutPut

        init(input: PokemonsListViewModelInput, output: PokemonsListViewModelOutPut) {
            self.input = input
            self.output = output
        }
    }

    class MockInput: PokemonsListViewModelInput {
        var didCallLoad: (() -> Void)?
        override func load() {
            didCallLoad?()
            super.load()
        }
    }

    class MockOutput: PokemonsListViewModelOutPut {
        var observer: ((Result) -> Void)?
        override func observePokemons( _ observer: @escaping (Result) -> Void) {
            self.observer = observer
            super.observePokemons(observer)
        }
    }
}

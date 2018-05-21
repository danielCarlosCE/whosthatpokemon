import XCTest

class AddFavoriteFlowTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddFavoriteDoesNavigateToFavoritesList() {
        let app = XCUIApplication()

        XCTAssert(app.otherElements["List.View"].waitForExistence(timeout: 1))

        let cellBulbasaur = app.otherElements["PokemonCell-1"]
        XCTAssert(cellBulbasaur.waitForExistence(timeout: 5))
        cellBulbasaur.tap()

        XCTAssert(app.otherElements["Details.View"].waitForExistence(timeout: 1))

        app.buttons["Details.Pokeball"].tap()

        XCTAssert(app.otherElements["Favorites.View"].waitForExistence(timeout: 1))
        XCTAssert(cellBulbasaur.waitForExistence(timeout: 2))
    }

}

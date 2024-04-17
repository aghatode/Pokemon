//
//  PokemonUITests.swift
//  PokemonUITests
//
//  Created by Aditi Patil on 13/04/2024.
//

import XCTest

final class PokemonUITests: XCTestCase {

    let app = XCUIApplication()
    

    override func setUp() {
        app.launch()
        let listScreen = app.searchFields["Search Pokemon..."]
            let listScreenExists = NSPredicate(format: "exists == true")
            expectation(for: listScreenExists, evaluatedWith: listScreen, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    func testValidateUI() {
        let window = app.windows.element(boundBy: 0)
        let collectionView = window.collectionViews.element(matching: .collectionView, identifier: "pokemonCollectionView")
        XCTAssert(collectionView.exists)
        XCTAssert(window.cells.element(matching: .cell, identifier: "pokemonCell").firstMatch.exists)
        XCTAssert(window.searchFields["Search Pokemon..."].exists)
    }
   
    func testSearchBar() {
        let window = app.windows.element(boundBy: 0)
        XCTAssert(window.searchFields["Search Pokemon..."].exists)
        let searchbar = window.searchFields["Search Pokemon..."]
        searchbar.tap()
        searchbar.typeText("bulbasaur")
        XCTAssert(window.cells.element(matching: .cell, identifier: "pokemonCell").firstMatch.exists)
        let cell = window.cells.element(matching: .cell, identifier: "pokemonCell").firstMatch
        let label = cell.staticTexts.matching(identifier: "pokemonNameLabel").firstMatch
        XCTAssertEqual(label.label,"Bulbasaur")
    }
    
    func testDetailScreen() {
        let window = app.windows.element(boundBy: 0)
        let collectionView = window.collectionViews.element(matching: .collectionView, identifier: "pokemonCollectionView")
        XCTAssert(collectionView.exists)
        XCTAssert(window.cells.element(matching: .cell, identifier: "pokemonCell").firstMatch.exists)
        window.cells.element(matching: .cell, identifier: "pokemonCell").firstMatch.tap()
        XCTAssert(window.tables.element(matching: .table, identifier: "statsTableView").exists)
        XCTAssert(window.collectionViews.element(matching: .collectionView, identifier: "typeCollectionView").exists)
        XCTAssert(window.images.matching(identifier: "customImageView").element.exists)
        XCTAssert(window.images.matching(identifier: "weightImageView").element.exists)
        XCTAssert(window.images.matching(identifier: "heightImageView").element.exists)
        XCTAssert(window.staticTexts.matching(identifier: "heightLabel").element.exists)
        XCTAssert(window.staticTexts.matching(identifier: "weightLabel").element.exists)
        
    }
}

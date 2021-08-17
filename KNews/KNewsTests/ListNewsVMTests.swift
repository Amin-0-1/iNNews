//
//  ListNewsVMTests.swift
//  KNewsTests
//
//  Created by Amin on 17/08/2021.
//

import XCTest
@testable import KNews
class ListNewsVMTests: XCTestCase {

    var listNewsVM: ListNewsVM!
    override func setUpWithError() throws {
        listNewsVM = ListNewsVM(useCase: ListNewsUsecase(repo: <#T##NewsRepoType#>))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

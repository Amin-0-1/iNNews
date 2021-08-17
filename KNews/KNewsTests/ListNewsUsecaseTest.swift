//
//  ListNewsUsecaseTest.swift
//  KNewsTests
//
//  Created by Amin on 17/08/2021.
//

import XCTest
@testable import KNews
class ListNewsUsecaseTest: XCTestCase {

    var listNewsUsecase: ListNewsUsecase!
    
    override func setUpWithError() throws {
        listNewsUsecase = ListNewsUsecase(repo: FakeRepo(shouldReturnError: false))
    }

    override func tearDownWithError() throws {
        listNewsUsecase = nil
    }

    func testFetchNews_success() throws{
        listNewsUsecase.fetchNews(pagination: true) { (result) in
            switch result{
            case .failure(_):
                XCTFail()
            case .success(let news):
                XCTAssertEqual(news.count, 20)
            }
        }
    }

    func testFetchNews_Fail() throws{
        listNewsUsecase = ListNewsUsecase(repo: FakeRepo(shouldReturnError: true))
        listNewsUsecase.fetchNews(pagination: true) { (result) in
            switch result{
            case .failure(_):
                return
            case .success(let news):
                XCTAssertEqual(news.count, 20)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

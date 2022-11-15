//
//  NewsMeAnotherTests.swift
//  NewsMeAnotherTests
//
//  Created by Антон Стафеев on 15.11.2022.
//
@testable import NewsMe
import XCTest

final class NewsMeAnotherTests: XCTestCase {

    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testApiCallCompletes() throws {
        try XCTSkipUnless(networkMonitor.isReachable, "Нужно интернет соединение")

      //given
        let urlString = "\(Constants.categoryURLString)\(Country.russia.rawValue)&category=\(NewsCategory.general.rawValue)"

      let url = URL(string: urlString)!
      let promise = expectation(description: "Completion Handler Invoked")
      var statusCode: Int?
      var responseError: Error?
      
      //when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)
      
      //then
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }
}

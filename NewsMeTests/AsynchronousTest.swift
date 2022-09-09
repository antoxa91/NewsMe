//
//  NewsMeTests.swift
//  NewsMeTests
//
//  Created by Антон Стафеев on 09.09.2022.
//

import XCTest
@testable import NewsMe

final class AsynchronousTest: XCTestCase {
    
    let timeout: TimeInterval = 2
    var expectation: XCTestExpectation!
    
    override func setUp() {
        expectation = expectation(description: "Server responds in reasonable time")
    }
    
    func test_decodeNews() {
        let url = URL(string: Constants.categoryURLString + Country.russia.rawValue + "&category=\(NewsCategory.general.rawValue)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {self.expectation.fulfill()}
            
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(APIResponse.self, from: data)
                )
            }
            catch {
                print(error)
            }
            
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
}

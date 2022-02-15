//
//  TawkDevTestTests.swift
//  TawkDevTestTests
//
//  Created by rlogical-dev-59 on 14/02/22.
//

@testable import TawkDevTest
import XCTest

class TawkDevTestTests: XCTestCase {
    let usersViewModel = UsersViewModel()

    func testFetchUsers() throws {
        let e = expectation(description: "testFetchUsers")

        usersViewModel.fetchUsers(since: 0) { result in
            switch result {
            case let .success(users):
                XCTAssertEqual(users.count > 0, true)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            e.fulfill()
        }

        waitForExpectations(timeout: 30.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}

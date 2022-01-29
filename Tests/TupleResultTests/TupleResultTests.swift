import XCTest
import TupleResult

final class TupleResultTests: XCTestCase {
    
    enum StubError: Error {
        case someError
    }
    
    func testSuccessResult() throws {
        execute(willSuccess: 1, willFailure: nil) {
            switch TupleResult(success: $0, failure: $1) {
            case .success(let success):
                XCTAssertEqual(success, 1)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSuccessSwiftResult() throws {
        execute(willSuccess: 1, willFailure: nil) {
            switch TupleResult(success: $0, failure: $1).value {
            case .success(let success):
                XCTAssertEqual(success, 1)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSuccessSwiftResultExtension() throws {
        execute(willSuccess: 1, willFailure: nil) {
            switch Result(success: $0, failure: $1) {
            case .success(let success):
                XCTAssertEqual(success, 1)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFailureResult() throws {
        execute(willSuccess: nil, willFailure: .someError) {
            switch TupleResult(success: $0, failure: $1) {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    func testFailureSwiftResult() throws {
        execute(willSuccess: nil, willFailure: .someError) {
            switch TupleResult(success: $0, failure: $1).value {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    func testFailureSwiftResultExtension() throws {
        execute(willSuccess: nil, willFailure: .someError) {
            switch Result(success: $0, failure: $1) {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    func testFailureAndSuccessResult() throws {
        execute(willSuccess: 1, willFailure: .someError) {
            switch TupleResult(success: $0, failure: $1) {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    func testFailureAndSuccessSwiftResult() throws {
        execute(willSuccess: 1, willFailure: .someError) {
            switch TupleResult(success: $0, failure: $1).value {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    func testFailureAndSuccessSwiftResultExtension() throws {
        execute(willSuccess: 1, willFailure: .someError) {
            switch Result(success: $0, failure: $1) {
            case .success:
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure, .someError)
            }
        }
    }
    
    private func execute(
        willSuccess: Int?,
        willFailure: StubError?,
        completion: (Int?, StubError?) -> Void) {
        completion(willSuccess, willFailure)
    }
    
}

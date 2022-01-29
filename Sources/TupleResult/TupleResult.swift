//
//  TupleResult.swift
//
//
//  Created by Ernest Hong on 2022/01/26.
//

import Foundation

public enum TupleResult<Success, Failure> where Failure: Error {
    
    case success(Success)
    case failure(Failure)
    
    public var value: Result<Success, Failure> {
        switch self {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    public init(success: Success?, failure: Failure?) {
        if let failure = failure {
            self = .failure(failure)
        } else if let success = success {
            self = .success(success)
        } else {
            fatalError("success or failure must be not nil")
        }
    }
                
    /// Returns a new result, mapping any success value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `Result`
    /// instance when it represents a success. The following example transforms
    /// the integer success value of a result into a string:
    ///
    ///     func getNextInteger() -> Result<Int, Error> { /* ... */ }
    ///
    ///     let integerResult = getNextInteger()
    ///     // integerResult == .success(5)
    ///     let stringResult = integerResult.map({ String($0) })
    ///     // stringResult == .success("5")
    ///
    /// - Parameter transform: A closure that takes the success value of this
    ///   instance.
    /// - Returns: A `Result` instance with the result of evaluating `transform`
    ///   as the new success value if this instance represents a success.
    @inlinable public func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        value.map(transform)
    }

    /// Returns a new result, mapping any failure value using the given
    /// transformation.
    ///
    /// Use this method when you need to transform the value of a `Result`
    /// instance when it represents a failure. The following example transforms
    /// the error value of a result by wrapping it in a custom `Error` type:
    ///
    ///     struct DatedError: Error {
    ///         var error: Error
    ///         var date: Date
    ///
    ///         init(_ error: Error) {
    ///             self.error = error
    ///             self.date = Date()
    ///         }
    ///     }
    ///
    ///     let result: Result<Int, Error> = // ...
    ///     // result == .failure(<error value>)
    ///     let resultWithDatedError = result.mapError({ e in DatedError(e) })
    ///     // result == .failure(DatedError(error: <error value>, date: <date>))
    ///
    /// - Parameter transform: A closure that takes the failure value of the
    ///   instance.
    /// - Returns: A `Result` instance with the result of evaluating `transform`
    ///   as the new failure value if this instance represents a failure.
    @inlinable public func mapError<NewFailure>(_ transform: (Failure) -> NewFailure) -> Result<Success, NewFailure> where NewFailure : Error {
        value.mapError(transform)
    }

    /// Returns a new result, mapping any success value using the given
    /// transformation and unwrapping the produced result.
    ///
    /// Use this method to avoid a nested result when your transformation
    /// produces another `Result` type.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an result type.
    ///
    ///     func getNextInteger() -> Result<Int, Error> {
    ///         .success(4)
    ///     }
    ///     func getNextAfterInteger(_ n: Int) -> Result<Int, Error> {
    ///         .success(n + 1)
    ///     }
    ///
    ///     let result = getNextInteger().map({ getNextAfterInteger($0) })
    ///     // result == .success(.success(5))
    ///
    ///     let result = getNextInteger().flatMap({ getNextAfterInteger($0) })
    ///     // result == .success(5)
    ///
    /// - Parameter transform: A closure that takes the success value of the
    ///   instance.
    /// - Returns: A `Result` instance, either from the closure or the previous
    ///   `.failure`.
    @inlinable public func flatMap<NewSuccess>(_ transform: (Success) -> Result<NewSuccess, Failure>) -> Result<NewSuccess, Failure> {
        value.flatMap(transform)
    }

    /// Returns a new result, mapping any failure value using the given
    /// transformation and unwrapping the produced result.
    ///
    /// - Parameter transform: A closure that takes the failure value of the
    ///   instance.
    /// - Returns: A `Result` instance, either from the closure or the previous
    ///   `.success`.
    @inlinable public func flatMapError<NewFailure>(_ transform: (Failure) -> Result<Success, NewFailure>) -> Result<Success, NewFailure> where NewFailure : Error {
        value.flatMapError(transform)
    }

    /// Returns the success value as a throwing expression.
    ///
    /// Use this method to retrieve the value of this result if it represents a
    /// success, or to catch the value if it represents a failure.
    ///
    ///     let integerResult: Result<Int, Error> = .success(5)
    ///     do {
    ///         let value = try integerResult.get()
    ///         print("The value is \(value).")
    ///     } catch {
    ///         print("Error retrieving the value: \(error)")
    ///     }
    ///     // Prints "The value is 5."
    ///
    /// - Returns: The success value, if the instance represents a success.
    /// - Throws: The failure value, if the instance represents a failure.
    @inlinable public func get() throws -> Success {
        try value.get()
    }
}

extension TupleResult where Success : Equatable, Failure : Equatable, Failure : Error {

    public static func != (lhs: TupleResult<Success, Failure>, rhs: TupleResult<Success, Failure>) -> Bool {
        lhs.value != rhs.value
    }
}

extension TupleResult : Equatable where Success : Equatable, Failure : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: TupleResult<Success, Failure>, b: TupleResult<Success, Failure>) -> Bool {
        a.value == b.value
    }
}

extension Result {
    
    public init(success: Success?, failure: Failure?) {
        self = TupleResult(success: success, failure: failure).value
    }
    
}

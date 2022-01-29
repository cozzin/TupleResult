# TupleResult
A micro library that easily converts c-style tuple result into Swift.Result

In some cases, the result of the completion handler is returned in the form of response and error tuple. In Swift5 and later, `Swift.Result` makes writing code more intuitive. Using `TupleResult`, you can easily change the tuple result type to `Swift.Result` type.

## Completion handler with response and error tuple
```swift
// Example

public func executeMethod(completion: (Response?, Error?) -> Void) {
    // when failure
    completion((nil, myError))

    // when success
    completion((myResponse, nil))
}
```

## 🧐 Before
```swift
import OtherModule

executeMethod { response, error in
    if let error = error {
        // handle failure
        return
    }

    guard let response = response else { return }

    // handle success
}
```

## 🚀 After
```swift
import TupleResult
import OtherModule

executeMethod {
    switch Result(success: $0, failure: $1) {
    case .success:
        // handle success
    case .failure(let failure):
        // handle failure
    }
}
```

## 💻 Installation

- [**Swift Package Manager**](https://swift.org/package-manager/)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/cozzin/TupleResult.git`) and click **Next**.
3. For **Rules**, select **Branch** (with branch set to `master`).
4. Click **Finish**.

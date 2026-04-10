# NDAMaps Swift SDK

Official Swift SDK for NDAMaps REST APIs.
Suitable for iOS, macOS, watchOS, and tvOS.

## Installation

Add via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ndamaps/sdk-swift.git", from: "0.1.0")
]
```

## Usage

```swift
import NDAMapsSDK

let options = ClientOptions(apiKey: "YOUR_API_KEY")
let client = NDAMapsClient(options: options)

Task {
    do {
        var params = AutocompleteGoogleParams(input: "Hồ Hoàn Kiếm")
        let result = try await client.places.autocomplete(&params)
        print(result["predictions"]!)
    } catch {
        print(error)
    }
}
```

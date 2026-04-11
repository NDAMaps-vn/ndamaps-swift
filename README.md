<p align="center">
  <img src="https://ndamaps.vn/logo.png" width="200" alt="NDAMaps Logo" />
</p>

# NDAMaps Swift SDK 🐦

The official Swift package for the [NDAMaps REST API](https://ndamaps.vn).
Suitable for iOS, macOS, watchOS, tvOS, and Linux (Server-Side Swift). Includes full support for Swift Concurrency (`async/await`) leveraging `URLSession`.

## 📦 Installation

Add this block to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ndamaps/sdk-swift.git", from: "0.1.0")
]
```
*Or, use the Xcode Package Manager (File > Add Packages).*

## 🚀 Quick Start

Initialize `NDAMapsClient` safely.

```swift
import NDAMapsSDK

let options = ClientOptions(apiKey: "YOUR_API_KEY")
let client = NDAMapsClient(options: options)

Task {
    do {
        // Example: Autocomplete Request
        var params = AutocompleteGoogleParams(input: "Hồ Hoàn Kiếm")
        let result = try await client.places.autocomplete(&params)
        
        if let predictions = result["predictions"] as? [[String: Any]] {
            print("Found \(predictions.count) predictions.")
        }
        
    } catch let error as NDAMapsError {
        print("NDAMaps Error: \(error.description)")
    } catch {
        print("Unknown Error: \(error)")
    }
}
```

## 🛠 Optimized Features

- **Billing Sessions**: `client.places.autocomplete(&params)` takes `inout params` to automatically embed a generated session UUID under the hood to `params.sessiontoken`.
- **Automatic Exponential Retries**: Transient network issues are heavily mitigated via `Task.sleep` without blocking the main UI thread.
- **Traveling Salesperson Optimization**: 

```swift
let routeParams = OptimizedRouteParams(locations: [
    OptimizedRouteLocation(lat: 21.03624, lon: 105.77142),
    OptimizedRouteLocation(lat: 21.03326, lon: 105.78743),
    OptimizedRouteLocation(lat: 21.00329, lon: 105.81834)
])
let optimizedRoute = try await client.navigation.optimizedRoute(routeParams)
```

## 🛑 Exceptions (`NDAMapsError`)
Explicit strongly-typed errors to catch API anomalies:
- `.invalidAPIKey(String)`
- `.placeNotFound(String)`
- `.rateLimitExceeded(String)`
- `.invalidParams(String)`
- `.networkError(String)`

## 📜 License
MIT License.

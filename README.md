<p align="center">
  <img src="https://ndamaps.vn/logo.png" width="200" alt="NDAMaps Logo" />
</p>

# NDAMaps Swift SDK

Official Swift package for **NDAMaps** — Vietnam's national digital map platform API.

Supports **iOS**, **macOS**, **watchOS**, **tvOS**, and **Linux** (server-side Swift). Uses `URLSession` and **Swift concurrency** (`async`/`await`).

## Features

- **Places** — Autocomplete (Google params) and place detail with **session tokens** (`inout` params)
- **Geocoding**, **Navigation** (including **optimized route**), **Maps**, **NDAView**, **Forcodes**
- **Retries** — Exponential backoff for transient failures (without blocking the main actor when used from async contexts)

## Requirements

- Swift toolchain with **async/await** (Swift 5.5+)

## Install

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/NDAMaps-vn/ndamaps-swift.git", from: "0.1.0")
]
```

Or use **Xcode → File → Add Package Dependencies**.

## Quick start

```swift
import NDAMapsSDK

let options = ClientOptions(apiKey: "YOUR_API_KEY")
let client = NDAMapsClient(options: options)

Task {
    do {
        var params = AutocompleteGoogleParams(input: "Hồ Hoàn Kiếm")
        let result = try await client.places.autocomplete(&params)

        if let predictions = result["predictions"] as? [[String: Any]] {
            print("Found \(predictions.count) predictions")
        }
    } catch let error as NDAMapsError {
        print("NDAMaps:", error.description)
    } catch {
        print(error)
    }
}
```

## Session tokens (billing)

`autocomplete(&params)` can inject `sessiontoken` into `params` for you. Call `placeDetail` afterward so the same token groups autocomplete + detail for billing.

## Navigation (optimized route)

```swift
let routeParams = OptimizedRouteParams(locations: [
    OptimizedRouteLocation(lat: 21.03624, lon: 105.77142),
    OptimizedRouteLocation(lat: 21.03326, lon: 105.78743),
    OptimizedRouteLocation(lat: 21.00329, lon: 105.81834),
])
let optimizedRoute = try await client.navigation.optimizedRoute(routeParams)
```

## Errors

`NDAMapsError` includes cases such as `invalidAPIKey`, `invalidForcode`, `placeNotFound`, `zeroResults`, `invalidParams`, `rateLimitExceeded`, `networkError`, `unknown`, and `invalidJSON`. Use pattern matching or `description` for logging.

## Links

- [NDAMaps documentation](https://docs.ndamaps.vn)
- [NDAMaps platform](https://ndamaps.vn)

## License

MIT

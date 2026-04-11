import Foundation
import NDAMapsSDK

@main
struct NDAMapsDemo {
    static func main() async {
        guard let apiKey = ProcessInfo.processInfo.environment["NDAMAPS_API_KEY"] else {
            print("Please set NDAMAPS_API_KEY environment variable")
            exit(1)
        }

        let client = NDAMapsClient(options: ClientOptions(apiKey: apiKey))

        print("--- 1. Forward Geocoding ---")
        do {
            var params = AutocompleteGoogleParams(input: "Hồ Hoàn Kiếm, Hà Nội")
            let geoRes = try await client.places.autocomplete(&params)
            
            if let predictions = geoRes["predictions"] as? [[String: Any]], let first = predictions.first {
                print("Result description: \(first["description"] ?? "")")
            }
        } catch {
            print("Error: \(error)")
        }

        print("\n--- 2. Optimized Route (Travelling Salesperson) ---")
        do {
            let p1 = OptimizedRouteLocation(lat: 21.03624, lon: 105.77142)
            let p2 = OptimizedRouteLocation(lat: 21.03326, lon: 105.78743)
            let p3 = OptimizedRouteLocation(lat: 21.00329, lon: 105.81834)
            
            let routeParams = OptimizedRouteParams(locations: [p1, p2, p3, p1], costing: "auto")
            let routeRes = try await client.navigation.optimizedRoute(routeParams)
            
            if let trip = routeRes["trip"] as? [String: Any],
               let summary = trip["summary"] as? [String: Any] {
                print("Total Distance: \(summary["length"] ?? 0) meters")
                print("Total ETA: \(summary["time"] ?? 0) seconds")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

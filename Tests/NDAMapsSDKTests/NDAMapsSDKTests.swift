import XCTest
@testable import NDAMapsSDK

final class NDAMapsSDKTests: XCTestCase {
    var client: NDAMapsClient!
    
    override func setUp() {
        let apiKey = ProcessInfo.processInfo.environment["NDAMAPS_API_KEY"] ?? "MISSING"
        client = NDAMapsClient(options: ClientOptions(apiKey: apiKey))
    }
    
    func testAutocomplete() async throws {
        let apiKey = ProcessInfo.processInfo.environment["NDAMAPS_API_KEY"]
        try XCTSkipIf(apiKey == nil, "API Key missing")
        
        var params = AutocompleteGoogleParams(input: "Hồ Hoàn Kiếm")
        let res = try await client.places.autocomplete(&params)
        XCTAssertEqual(res["status"] as? String, "OK")
        XCTAssertNotNil(res["predictions"])
    }
    
    func testDistanceMatrix() async throws {
        let apiKey = ProcessInfo.processInfo.environment["NDAMAPS_API_KEY"]
        try XCTSkipIf(apiKey == nil, "API Key missing")
        
        let params = DistanceMatrixParams(
            sources: [DistanceMatrixLocation(lat: 21.03, lon: 105.79)],
            targets: [DistanceMatrixLocation(lat: 21.05, lon: 105.79)]
        )
        let res = try await client.navigation.distanceMatrix(params)
        XCTAssertNotNil(res["sources_to_targets"])
    }
    
    func testOptimizedRoute() async throws {
        let apiKey = ProcessInfo.processInfo.environment["NDAMAPS_API_KEY"]
        try XCTSkipIf(apiKey == nil, "API Key missing")
        
        let params = OptimizedRouteParams(locations: [
            OptimizedRouteLocation(lat: 21.03624, lon: 105.77142),
            OptimizedRouteLocation(lat: 21.03326, lon: 105.78743),
            OptimizedRouteLocation(lat: 21.00329, lon: 105.81834),
            OptimizedRouteLocation(lat: 21.03624, lon: 105.77142)
        ])
        let res = try await client.navigation.optimizedRoute(params)
        let trip = res["trip"] as? [String: Any]
        XCTAssertNotNil(trip)
        let locations = trip?["locations"] as? [Any]
        XCTAssertEqual(locations?.count, 4)
    }
}

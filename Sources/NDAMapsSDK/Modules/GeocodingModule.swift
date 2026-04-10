import Foundation

public class GeocodingModule {
    unowned let client: NDAMapsClient
    init(client: NDAMapsClient) { self.client = client }
    
    public func forwardGoogle(_ params: ForwardGeocodeGoogleParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "address", value: params.address)]
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/geocode/forward", query: query)
    }
    
    public func forwardOsm(_ params: ForwardGeocodeOsmParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "text", value: params.text)]
        if let v = params.size { query.append(URLQueryItem(name: "size", value: String(v))) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/geocode/forward", query: query)
    }
    
    public func reverseGoogle(_ params: ReverseGeocodeGoogleParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "latlng", value: params.latlng)]
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/geocode/reverse", query: query)
    }
    
    public func reverseOsm(_ params: ReverseGeocodeOsmParams) async throws -> [String: Any] {
        var query = [
            URLQueryItem(name: "point.lat", value: String(params.pointLat)),
            URLQueryItem(name: "point.lon", value: String(params.pointLon))
        ]
        if let v = params.boundaryCircleRadius { query.append(URLQueryItem(name: "boundary.circle.radius", value: String(v))) }
        if let v = params.size { query.append(URLQueryItem(name: "size", value: String(v))) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/geocode/reverse", query: query)
    }
}

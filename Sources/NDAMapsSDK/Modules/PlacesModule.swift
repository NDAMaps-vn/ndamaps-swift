import Foundation

public class PlacesModule {
    unowned let client: NDAMapsClient
    
    init(client: NDAMapsClient) { self.client = client }
    
    public func autocomplete(_ params: inout AutocompleteGoogleParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "input", value: params.input)]
        if let v = params.location { query.append(URLQueryItem(name: "location", value: v)) }
        if let v = params.origin { query.append(URLQueryItem(name: "origin", value: v)) }
        if let v = params.radius { query.append(URLQueryItem(name: "radius", value: String(v))) }
        if let v = params.size { query.append(URLQueryItem(name: "size", value: String(v))) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }

        if params.sessiontoken == nil {
            params.sessiontoken = client.sessionManager.getOrCreate()
        }
        if let t = params.sessiontoken { query.append(URLQueryItem(name: "sessiontoken", value: t)) }
        
        return try await client.get(base: client.mapsApiBase, path: "/autocomplete", query: query)
    }
    
    public func autocompleteOsm(_ params: inout AutocompleteOsmParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "text", value: params.text)]
        if let v = params.boundaryCircleLat { query.append(URLQueryItem(name: "boundary.circle.lat", value: String(v))) }
        if let v = params.boundaryCircleLon { query.append(URLQueryItem(name: "boundary.circle.lon", value: String(v))) }
        if let v = params.boundaryCircleRadius { query.append(URLQueryItem(name: "boundary.circle.radius", value: String(v))) }
        if let v = params.size { query.append(URLQueryItem(name: "size", value: String(v))) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        if let t = params.sessiontoken { query.append(URLQueryItem(name: "sessiontoken", value: t)) }
        
        return try await client.get(base: client.mapsApiBase, path: "/autocomplete", query: query)
    }
    
    public func placeDetail(_ params: inout PlaceDetailParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "ids", value: params.ids)]
        if let v = params.format { query.append(URLQueryItem(name: "format", value: v)) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        
        if params.sessiontoken == nil {
            if let cur = client.sessionManager.getCurrent() {
                params.sessiontoken = cur
                client.sessionManager.reset()
            }
        }
        if let t = params.sessiontoken { query.append(URLQueryItem(name: "sessiontoken", value: t)) }
        
        return try await client.get(base: client.mapsApiBase, path: "/place", query: query)
    }
    
    public func children(_ params: PlaceChildrenParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "parent_id", value: params.parentId)]
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/place/children", query: query)
    }
    
    public func nearby(_ params: NearbyParams) async throws -> [String: Any] {
        var query = [URLQueryItem(name: "categories", value: params.categories)]
        if let v = params.pointLat { query.append(URLQueryItem(name: "point.lat", value: String(v))) }
        if let v = params.pointLon { query.append(URLQueryItem(name: "point.lon", value: String(v))) }
        if let v = params.size { query.append(URLQueryItem(name: "size", value: String(v))) }
        if let v = params.boundaryCircleRadius { query.append(URLQueryItem(name: "boundary.circle.radius", value: String(v))) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        return try await client.get(base: client.mapsApiBase, path: "/nearby", query: query)
    }
}

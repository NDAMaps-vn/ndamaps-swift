import Foundation

public class NavigationModule {
    unowned let client: NDAMapsClient
    init(client: NDAMapsClient) { self.client = client }
    
    public func directions(_ params: DirectionsParams) async throws -> [String: Any] {
        var query = [
            URLQueryItem(name: "origin", value: params.origin),
            URLQueryItem(name: "destination", value: params.destination)
        ]
        if let v = params.vehicle { query.append(URLQueryItem(name: "vehicle", value: v.rawValue)) }
        if let v = params.alternatives { query.append(URLQueryItem(name: "alternatives", value: String(v))) }
        if let v = params.language { query.append(URLQueryItem(name: "language", value: v)) }
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        
        return try await client.get(base: client.mapsApiBase, path: "/direction", query: query)
    }
    
    public func distanceMatrix(_ params: DistanceMatrixParams) async throws -> [String: Any] {
        var jsonDict: [String: Any] = [:]
        
        let sourcesData = try JSONEncoder().encode(params.sources)
        let targetsData = try JSONEncoder().encode(params.targets)
        
        jsonDict["sources"] = try JSONSerialization.jsonObject(with: sourcesData)
        jsonDict["targets"] = try JSONSerialization.jsonObject(with: targetsData)
        
        let bodyData = try JSONSerialization.data(withJSONObject: jsonDict)
        let jsonStr = String(data: bodyData, encoding: .utf8) ?? "{}"
        
        var query = [URLQueryItem(name: "json", value: jsonStr)]
        if let v = params.id { query.append(URLQueryItem(name: "id", value: v)) }
        if let v = params.verbose { query.append(URLQueryItem(name: "verbose", value: String(v))) }
        if let v = params.shapeFormat { query.append(URLQueryItem(name: "shape_format", value: v)) }
        
        return try await client.get(base: client.mapsApiBase, path: "/distancematrix", query: query)
    }
    
    public func optimizedRoute(_ params: OptimizedRouteParams) async throws -> [String: Any] {
        var jsonDict: [String: Any] = [:]
        
        let locationsData = try JSONEncoder().encode(params.locations)
        jsonDict["locations"] = try JSONSerialization.jsonObject(with: locationsData)
        
        if let c = params.costing {
            jsonDict["costing"] = c
        } else {
            jsonDict["costing"] = "auto"
        }
        
        if let opt = params.directionsOptions {
            jsonDict["directions_options"] = opt
        }
        
        let bodyData = try JSONSerialization.data(withJSONObject: jsonDict)
        let jsonStr = String(data: bodyData, encoding: .utf8) ?? "{}"
        
        var query = [URLQueryItem(name: "json", value: jsonStr)]
        if let v = params.admin_v2 { query.append(URLQueryItem(name: "admin_v2", value: String(v))) }
        
        return try await client.get(base: client.mapsApiBase, path: "/optimized-route", query: query)
    }
}

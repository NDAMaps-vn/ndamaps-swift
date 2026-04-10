import Foundation

public class NDAViewModule {
    unowned let client: NDAMapsClient
    init(client: NDAMapsClient) { self.client = client }
    
    public func staticThumbnailUrl(_ params: NdaViewStaticParams) -> String {
        var comps = URLComponents(string: "\(client.ndaviewBase)/items/static/thumbnail.jpeg")!
        var query = [URLQueryItem(name: "apikey", value: client.apiKey)]
        if let id = params.id { query.append(URLQueryItem(name: "id", value: id)) }
        if let p = params.placePosition { query.append(URLQueryItem(name: "place_position", value: "\(p.lng),\(p.lat)")) }
        if let y = params.yaw { query.append(URLQueryItem(name: "yaw", value: String(y))) }
        if let pit = params.pitch { query.append(URLQueryItem(name: "pitch", value: String(pit))) }
        comps.queryItems = query
        return comps.url!.absoluteString
    }
    
    public func search(_ params: NdaViewSearchParams) async throws -> [String: Any] {
        var query: [URLQueryItem] = []
        if let p = params.placePosition { query.append(URLQueryItem(name: "place_position", value: "\(p.lng),\(p.lat)")) }
        if let v = params.placeDistance { query.append(URLQueryItem(name: "place_distance", value: v)) }
        if let v = params.placeFovTolerance { query.append(URLQueryItem(name: "place_fov_tolerance", value: String(v))) }
        if let v = params.bbox { query.append(URLQueryItem(name: "bbox", value: v)) }
        if let v = params.datetime { query.append(URLQueryItem(name: "datetime", value: v)) }
        if let v = params.limit { query.append(URLQueryItem(name: "limit", value: String(v))) }
        if let v = params.ids { query.append(URLQueryItem(name: "ids", value: v)) }
        if let v = params.collections { query.append(URLQueryItem(name: "collections", value: v)) }
        
        return try await client.get(base: client.ndaviewBase, path: "/search", query: query)
    }
}

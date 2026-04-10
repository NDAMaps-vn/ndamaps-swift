import Foundation

public class ForcodesModule {
    unowned let client: NDAMapsClient
    init(client: NDAMapsClient) { self.client = client }
    
    public func encode(_ params: ForcodeEncodeParams) async throws -> [String: Any] {
        var query = [
            URLQueryItem(name: "lat", value: String(params.lat)),
            URLQueryItem(name: "lng", value: String(params.lng))
        ]
        if let r = params.resolution { query.append(URLQueryItem(name: "resolution", value: String(r))) }
        return try await client.post(base: client.mapsApiBase, path: "/forcodes/encode", query: query, body: nil)
    }
    
    public func decode(_ params: ForcodeDecodeParams) async throws -> [String: Any] {
        let query = [URLQueryItem(name: "forcodes", value: params.forcodes)]
        return try await client.post(base: client.mapsApiBase, path: "/forcodes/decode", query: query, body: nil)
    }
}

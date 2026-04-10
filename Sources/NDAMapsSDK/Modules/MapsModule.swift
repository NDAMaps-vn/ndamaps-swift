import Foundation

public class MapsModule {
    unowned let client: NDAMapsClient
    init(client: NDAMapsClient) { self.client = client }
    
    public func styleUrl(styleId: String = "day-v1") -> String {
        return "\(client.tilesBase)/styles/\(styleId)/style.json?apikey=\(client.apiKey)"
    }
    
    public func staticMapUrl(_ params: StaticMapParams) -> String {
        let style = params.styleId ?? "ndamap"
        let format = params.format ?? "png"
        let sizeStr = params.retina ? "\(params.width)x\(params.height)@2x" : "\(params.width)x\(params.height)"
        
        var centerPath = "auto"
        switch params.mode {
        case .center(let center, let zoom, let bearing, let pitch):
            centerPath = "\(center.lng),\(center.lat),\(zoom)"
            if let b = bearing {
                centerPath += "@\(b)"
                if let p = pitch { centerPath += ",\(p)" }
            }
        case .area(let minLon, let minLat, let maxLon, let maxLat):
            centerPath = "\(minLon),\(minLat),\(maxLon),\(maxLat)"
        case .auto:
            centerPath = "auto"
        }
        
        let base = "\(client.tilesBase)/styles/\(style)/static/\(centerPath)/\(sizeStr).\(format)"
        
        var comps = URLComponents(string: base)!
        var query = [URLQueryItem(name: "apikey", value: client.apiKey)]
        if let m = params.marker { query.append(URLQueryItem(name: "marker", value: m)) }
        if let p = params.path { query.append(URLQueryItem(name: "path", value: p)) }
        if let p = params.padding { query.append(URLQueryItem(name: "padding", value: String(p))) }
        comps.queryItems = query
        
        return comps.url!.absoluteString
    }
}

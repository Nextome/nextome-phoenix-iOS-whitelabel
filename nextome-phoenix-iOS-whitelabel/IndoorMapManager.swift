//
//  FlutterMapManager.swift
//  iosApp
//
//  Created by Pasquale Guida on 15/05/25.
//  Copyright © 2025 Nextome srl. All rights reserved.
//

import Foundation
import NextomeLocalization
import NextomeMapView

class IndoorMapManager {
    
    final var FLUTTERMAP_INDOOR_LAYER_PATHS = "PathsLayer"
    final var FLUTTERMAP_INDOOR_LAYER_MARKERS = "MarkersLayer"

    var flutterMap = NextomeMapViewHandler.instance
    
    var indoorBluedotMarker: NMMarker = NMMarker()
    var indoorPath: NMPath = NMPath()
    
    var flutterMapReady = false
    
    func loadMapTiles(mapId: Int, mapTilesUrl: String, mapHeight: Int, mapWidth: Int){
        var tile: NMTile = NMTile(name: "\(mapId)", id: "\(mapId)", source: mapTilesUrl)
        tile.show = true
        flutterMap.setResources(tiles: [tile], zoom: 1, width: mapWidth, height: mapHeight)
    }
    
    func setIndoorMapItems(){
        
        flutterMap.addLayer(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS)
        flutterMap.addLayer(layerId: FLUTTERMAP_INDOOR_LAYER_MARKERS)
        
        flutterMap.setLayerVisibility(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, show: false)
        flutterMap.setLayerVisibility(layerId: FLUTTERMAP_INDOOR_LAYER_MARKERS, show: true)
        
        let blueDotFile = self.getPath(filename: "current_position")
        if(blueDotFile != nil){
            indoorBluedotMarker.id = "indoorBluedotMarker"
            indoorBluedotMarker.x = 0
            indoorBluedotMarker.y = 0
            indoorBluedotMarker.width = 50.0
            indoorBluedotMarker.height = 50.0
            indoorBluedotMarker.source = blueDotFile!
            indoorBluedotMarker.sourceType = .FILESYSTEM

            flutterMap.addMarker(layerId: FLUTTERMAP_INDOOR_LAYER_MARKERS, marker: indoorBluedotMarker)
        }else{
            print("Cannot create indoorBluedotMarker")
        }

        
        indoorPath.id = "indoorPath"
        indoorPath.color = NMColor(r: 120, g: 200, b: 255)
        indoorPath.width = 6.0
        indoorPath.style = NMLineStyle.NORMAL
        indoorPath.points = [NMPoint(x: 0, y: 0), NMPoint(x: 1, y: 1)]
        
        flutterMap.addPath(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, path: indoorPath)
        
        flutterMap.apply()
        
        flutterMapReady = true
    }
    
    func updateBluedotMarker(position: NextomePosition, callApply: Bool = false){
        if(!flutterMapReady){
            return
        }
        
        indoorBluedotMarker.x = position.x
        indoorBluedotMarker.y = position.y
        
        flutterMap.updateMarker(layerId: FLUTTERMAP_INDOOR_LAYER_MARKERS, marker: indoorBluedotMarker)
        
        if(callApply){
            flutterMap.apply()
        }
    }
    
    func clearPathAndMarker(callApply: Bool = false){
        if(!flutterMapReady){
            return
        }
        
        indoorPath.points.removeAll()
        flutterMap.updatePath(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, path: indoorPath)
        
        flutterMap.setLayerVisibility(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, show: false)
        
        if(callApply){
            flutterMap.apply()
        }
    }
    
    func drawPath(path: Array<Vertex>, callApply: Bool = false){
        if(!flutterMapReady){
            return
        }
        
        var points: Array<NMPoint> = []
        path.forEach { v in
            points.append( NMPoint(x: v.x, y: v.y))
        }
        
        indoorPath.points = points
        flutterMap.updatePath(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, path: indoorPath)
        
        flutterMap.setLayerVisibility(layerId: FLUTTERMAP_INDOOR_LAYER_PATHS, show: true)
        
        if(callApply){
            flutterMap.apply()
        }
    }
 
    func buildPois(pois: [NextomePoi]){
        
            pois.forEach { poi in
                let poiMarkerFile = self.getPath(filename: "poi_colored")
                if(poiMarkerFile != nil){
                    let poiMarker: NMMarker = NMMarker()
                    poiMarker.id = "poi_\(poi.id)"
                    poiMarker.x = poi.x
                    poiMarker.y = poi.y
                    poiMarker.width = 50.0
                    poiMarker.height = 50.0
                    poiMarker.source = poiMarkerFile!
                    poiMarker.sourceType = .FILESYSTEM
                    flutterMap.addMarker(layerId: FLUTTERMAP_INDOOR_LAYER_MARKERS, marker: poiMarker)
                }
            }

        flutterMap.apply()
    }
    
    // MARK: Helper -------------------------------------
    
    private func getPath(filename: String, fileType: String = "png") -> String? {
        print("Bundle.main.resourcePath:", Bundle.main.resourcePath ?? "nil")
        if let items = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath ?? "") {
            print("Files:", items)
        }

        guard let bundlePath = Bundle.main.path(forResource: filename, ofType: fileType) else {
            print("FlutterMapManager.getPath no path found for file: \(filename).\(fileType)")
            return nil
        }
        print("FlutterMapManager.getPath found path is " + bundlePath)

        if(fileType == "png"){
            if let tmpPath = normalizeAndWriteToTemp(originalPath: bundlePath, filename: filename, fileType: fileType) {
                print("Normalized image saved to tmp: \(tmpPath)")
                return tmpPath
            } else {
                print("Normalization failed, returning original bundle path (may not be readable by Flutter)")
                return bundlePath
            }
        } else {
            if let path = Bundle.main.path(forResource: filename, ofType: fileType){
                print("FlutterMapManager.getPath found path is " + path)
                return path
            }else{
                print("FlutterMapManager.getPath no path found for file: \(filename).\(fileType)")
            }
        }
        return nil
    }

    func normalizedImage(from path: String) -> UIImage? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let image = UIImage(data: data) else {
            print("normalizedImage: cannot load data/image from path: \(path)")
            return nil
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        format.opaque = false
        format.preferredRange = .standard

        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        let normalized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }

        return normalized
    }

    @discardableResult
    func normalizeAndWriteToTemp(originalPath: String, filename: String, fileType: String = "png") -> String? {
        guard let normalized = normalizedImage(from: originalPath) else {
            print("normalizeAndWriteToTemp: normalized conversion failed")
            return nil
        }

        guard let pngData = normalized.pngData() else {
            print("normalizeAndWriteToTemp: cannot get pngData()")
            return nil
        }

        let tmpDir = FileManager.default.temporaryDirectory
        let tmpFilename = "\(filename)-normalized.\(fileType)"
        let tmpURL = tmpDir.appendingPathComponent(tmpFilename)

        do {
            try pngData.write(to: tmpURL, options: .atomic)
            let exists = FileManager.default.fileExists(atPath: tmpURL.path)
            let attrs = try FileManager.default.attributesOfItem(atPath: tmpURL.path)
            print("normalizeAndWriteToTemp: wrote file at \(tmpURL.path), exists: \(exists), size: \(attrs[.size] ?? "unknown")")
            return tmpURL.path
        } catch {
            print("normalizeAndWriteToTemp: write error: \(error)")
            return nil
        }
    }
}



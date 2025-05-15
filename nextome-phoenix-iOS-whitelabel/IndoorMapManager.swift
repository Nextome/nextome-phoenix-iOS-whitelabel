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
        
        let resPath = Bundle.main.resourcePath

        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: resPath!)
            for item in items {
                print ("   item: " + item)
            }
        } catch {
            print("IndoorMapManager.getPath exception: \(error)")
        }
        
        
        if let path = Bundle.main.path(forResource: filename, ofType: fileType){
            print("IndoorMapManager.getPath found path is " + path)
            return path
        }else{
            print("IndoorMapManager.getPath no path found for file: \(filename).\(fileType)")
        }
        
        return nil
    }
}



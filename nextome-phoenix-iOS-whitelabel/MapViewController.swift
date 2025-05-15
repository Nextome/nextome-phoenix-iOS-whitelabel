//
//  MapViewController.swift
//  iosApp
//
//  Created by Anna Labellarte on 14/09/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import BLTNBoard
import NextomeLocalization
import Sheeeeeeeeet
import Toast_Swift

import NextomeMapView

class MapViewController: UIViewController {

    let CLIENT_ID = "CLIENT_ID"
    let CLIENT_SECRET = "CLIENT_SECRET"
    
    var nextomeSdk: NextomeLocalizationSdk!
    var viewModel = MapViewModel()
    
    let openSettingsSegue = "openSettings"
    let TAG = "MapViewController"
    let openPoiListSegue = "openPoiList"
    
    @IBOutlet weak var exitNavigationButton: UIButton!
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusProgress: UIProgressView!
    @IBOutlet weak var statusLabel: UILabel!

    var firstTime = true
    var isShowingPath = false
    var targetPathPoi: NextomePoi? = nil
    var watchers: [Ktor_ioCloseable] = []
    var lastPosition: NextomePosition? = nil
    var currentVC: UIViewController? = nil
    
    var pois: Array<NextomePoi> = []
    
    lazy var outdoorMapViewController: UIViewController = {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "OutdoorMapViewController") as! OutdoorMapViewController
        return controller
    }()
    
    lazy var indoorMapViewController: UIViewController = UIViewController()

    var mapManager: IndoorMapManager = IndoorMapManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        openOutdoorMap()
        statusProgress.startIndefinateProgress()
        setupTheme()
        initNextomeSdk()
        observeSdkResults()
        nextomeSdk.start()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(self.isMovingFromParent){
            nextomeSdk.stop()
            watchers.forEach({$0.close()})
        }
    }
    
    func setupTheme(){
        let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           appearance.backgroundColor = UIColor(named: "PrimaryColor")
           let proxy = UINavigationBar.appearance()
           proxy.tintColor = .white
           proxy.standardAppearance = appearance
           proxy.scrollEdgeAppearance = appearance
    }
    
    func initNextomeSdk(){
        let appSettings = viewModel.appSettings
        nextomeSdk = NextomeLocalizationSdkUtils.getSdkBuilder(fromSettings: appSettings, clientId: CLIENT_ID, clientSecret: CLIENT_SECRET).build()
    }
    
    func observeSdkResults(){
        observeSdkState()
        observeSdkLocations()
        observeExitEvents()
        observeEnterEvents()
        observeErrors()
    }
    
    // MARK: - UI CALLBACKS
           
    @IBAction func onMenuClicked(_ sender: Any) {
        let poiButton = MenuItem(title: L10n.menuShowPoi)
        let settingsButton = MenuItem(title: L10n.menuShowSettings)
        let cancelButton = CancelButton(title: L10n.genericCancel)
        let menu = Menu(title: "", items: [poiButton, settingsButton, cancelButton])
        let sheet = menu.toActionSheet { sheet, item in
            switch item.title {
            case poiButton.title:
                self.openPoiList()
            case settingsButton.title:
                self.openSettings()
            case L10n.genericCancel:
                return
            default:
                self.view.superview?.makeToast("Not implemented")
                
            }
        }
        sheet.present(in: self, from: menuButton)
    }

    
    @IBAction func onExitNavigationClicked(_ sender: Any) {
        clearPathOnMap()
    }
    
    
    func openSettings(){
        self.performSegue(withIdentifier: openSettingsSegue, sender: self)

    }
    
    func openPoiList(){
        self.performSegue(withIdentifier: openPoiListSegue, sender: self)
    }
    
    // MARK: - SDK OBSERVERS
    
    func observeSdkLocations(){
        let watcher = nextomeSdk.getLocalizationObservable().watch(block: {position in
            if let position = position{
                self.lastPosition = position
                self.updatePositionOnFlutterMap(position: position)
            }
        })

        watchers.append(watcher)
    }
    
    
    func observeSdkState(){
        let watcher = nextomeSdk.getStateObservable().watch(block: {state in
            
            guard let state = state else {return }
            if state is IdleState{
                self.openOutdoorMap()
                self.viewModel.venueSettings = nil
                self.viewModel.poiList = nil
                self.changeAlertText("Sdk is Idle")
            }else if state is StartedState{
                self.openOutdoorMap()
                self.viewModel.venueSettings = nil
                self.viewModel.poiList = nil
                self.changeAlertText("Sdk Started")
            }else if state is SearchVenueState{
                self.viewModel.poiList = nil
                self.openOutdoorMap()
                self.viewModel.venueSettings = nil
                self.changeAlertText("Searching Venue")
            }else if let getPacketState = state as? GetPacketState{
                self.changeAlertText("Downloading venue \(getPacketState.venueId)...")
            }else if let findFloorState = state as? FindFloorState{
                self.changeAlertText("Finding current Floor on venue \(findFloorState.venueId)...")
                self.viewModel.venueSettings = findFloorState.venueData.settings
            }else if let runningState = state as? LocalizationRunningState{
                print("State is RUNNING")
                self.statusView.isHidden = true
                
                self.initFlutter(onInitialized: {
                    self.openIndoorMap()
                    self.setMap(mapId: Int(runningState.mapId), mapTilesUrl: runningState.tilesZipPath, mapHeight: Int(runningState.mapHeight), mapWidth: Int(runningState.mapWidth))
                    self.observeFlutterMapEvents()
                })
                
                self.viewModel.venueSettings = runningState.venueData.settings
                self.viewModel.poiList = runningState.venueData.allPois
                
                self.pois = runningState.venueData.getReachablePoisByMapId(mapId: runningState.mapId)
            }
        })
        watchers.append(watcher)
    }
    
    func initFlutter(onInitialized: @escaping () -> Void){
        
        NextomeMapViewHandler.instance.initialize {
            self.indoorMapViewController = NextomeMapViewHandler.instance.getFlutterViewController()!
            onInitialized()
        }

        mapManager.flutterMap.setOnMapReady {
            self.mapManager.setIndoorMapItems()
            self.mapManager.buildPois(pois: self.pois)
        }
    }
    
    func destroyFlutter(){
        NextomeMapViewHandler.instance.destroy(vc: self.indoorMapViewController) {
            // Do nothing
        }
    }
    
    func setMap(mapId: Int, mapTilesUrl: String, mapHeight: Int, mapWidth: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // await 1 second
            self.mapManager.loadMapTiles(mapId: mapId, mapTilesUrl: mapTilesUrl, mapHeight: mapHeight, mapWidth: mapWidth)
        }
    }
    
    func observeFlutterMapEvents(){
        mapManager.flutterMap.setOnMarkerTap { marker in
            let poi: NextomePoi? = self.getNextomePoiFromMapMarker(marker: marker)
            if(self.lastPosition != nil && poi != nil){
                self.onNavigationSelected(poi: poi!)
            }
        }
    }
    
    func getNextomePoiFromMapMarker(marker: NMMarker) -> NextomePoi? {
        
        if(marker.id != nil && marker.id!.starts(with: "poi_")){
            let idStr = marker.id!.replacingOccurrences(of: "poi_", with: "")
            let id: Int? = Int(idStr)
            if(id != nil){
                let res = pois.filter { $0.id == id! }
                return res.isEmpty ? nil : res[0]
            }
        }
        
        return nil
    }
    
    func observeErrors(){
        let errorWatcher = nextomeSdk.getErrorsObservable().watch(block: {error in
            guard let error = error else{
                return
            }
            self.viewModel.handleError(error: error)
        })
        watchers.append(errorWatcher)
    }
    
    func onPoiClicked(poi: NextomePoi) {
        print("Poi clicked")
    }
    
    func onNavigationSelected(poi: NextomePoi) {
        if let position = lastPosition{
            self.updatePathOnMap(position.venueId, position.x, position.y, position.mapId, poi.x, poi.y, poi.venueId)
            self.targetPathPoi = poi
            self.isShowingPath = true
        }
    }
    
    func handleError(_ error: NextomeException){
        if error is GenericException{
            showGenericError(message: error.message)
        }else if let authError = error as? InvalidCredentialException{
            showAuthErrorAlertAndLogout(authError.message)
        }

    }
    
    func showAuthErrorAlertAndLogout(_ error: String){
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.genericOk, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeAlertText(_ message: String){
        statusView.isHidden = false
        statusLabel.text = message
    }
    
    func updatePositionOnFlutterMap(position: NextomePosition){
        updatePointOnMap(position: position)
        updatePathOnMap(position: position)
    }
    
    func updatePointOnMap(position: NextomePosition){
        self.mapManager.updateBluedotMarker(position: position, callApply: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SettingsViewController{
            vc.type = .MAP(venueSettings: viewModel.venueSettings)
        }else if let vc = segue.destination as? PoiListViewController{
            vc.poiList = viewModel.poiList ?? []
            vc.onPoiSelected = { self.onPoiReceived(poi: $0) }
        }
    }
    

    
}

//MARK: PATH
extension MapViewController{
    func onPoiReceived(poi: NextomePoi){
        if let lastPosition = lastPosition{
            updatePathOnMap(lastPosition.venueId,
                          lastPosition.x,
                          lastPosition.y,
                          lastPosition.mapId,
                          poi.x, poi.y, poi.map)
            targetPathPoi = poi
            isShowingPath = true
        }
    }
    
    func updatePathOnMap(_ venueId: Int32, _ startX: Double, _ startY: Double,_ startMapId: Int32,_ targetX: Double, _ targetY: Double,_ targetMapId: Int32){
        guard let lastPosition = lastPosition else{
            return
        }
        nextomeSdk.findPath(venueId: venueId, sourceX: startX, sourceY: startY, sourceMap: startMapId, destX: targetX, destY: targetY, destMap: targetMapId, completionHandler: {vertex, error in
            guard let vertex = vertex else{
                return
            }
            
            let path = vertex.filter({$0.z == lastPosition.mapId})
            DispatchQueue.main.async {
                self.exitNavigationButton.isHidden = false
                self.mapManager.drawPath(path: path)
            }
        })
    }
    
    func updatePathOnMap(position: NextomePosition){
        if isShowingPath, let targetPathPoi = targetPathPoi{
            updatePathOnMap(position.venueId, position.x, position.y, position.mapId, targetPathPoi.x, targetPathPoi.y, targetPathPoi.map)
        }
    }
    
    private func clearPathOnMap(){
        exitNavigationButton.isHidden = true
        isShowingPath = false
        self.mapManager.clearPathAndMarker(callApply: true)
    }
}

//MARK: Event handler
extension MapViewController{
    
    func observeEnterEvents(){
        let watcher = nextomeSdk.getEnterEventObservable().watch(block: { event in
            guard let event = event else{
                return
            }
            self.showEventDialog(eventId: event.event.id, message: "Enter event \(event.event.id)")
        })
        
        watchers.append(watcher)
    }
    
    func observeExitEvents(){
        let watcher = nextomeSdk.getExitEventObservable().watch(block: { event in
            guard let event = event else{
                return
            }
            self.showEventDialog(eventId: event.event.id, message: "Exit event \(event.event.id)")
        })
        
        watchers.append(watcher)
        
    }
    
    func showEventDialog(eventId: Int64, message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: L10n.genericOk, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//SECTION: Error handler
extension MapViewController: MapDelegate{
    
    func onAuthenticationError(message: String){
        
        view.superview?.makeToast(message, completion: {_ in
            self.dismiss(animated: true)
        })
    }
    
    func showGenericError(message: String){
        view.superview?.makeToast(message)
    }
}

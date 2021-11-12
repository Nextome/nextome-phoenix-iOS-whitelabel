//
//  AppDelegate.swift
//  Nextome Indoor Positioning
//
//  Created by Francesco Paolo Dellaquila on 17/06/2020.
//  Copyright © 2020 Nextome. All rights reserved.
//

import UIKit
import PhoenixSdk
import Flutter
import FlutterPluginRegistrant
import NVActivityIndicatorView
import SideMenu
import PKHUD
import BLTNBoard
import Firebase

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {

    //nextome sdk
    var sdk: NextomeSdk?
    //flutter engine
    var flutterEngine : FlutterEngine?
    //flutter controller
    var flutterViewController : FlutterViewController?
    //binding channel between flutter and iOS
    var mapChannel = FlutterMethodChannel()
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initComponents()

        //FirebaseApp.configure()
        return true
    }
    
    
    private func initComponents(){
        
        //MARK: FLUTTER init
        //1. engine
        self.flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
        //2.run
        self.flutterEngine?.run(withEntrypoint: nil)
        
        //3.plugin registrant
        GeneratedPluginRegistrant.register(with: self.flutterEngine!)
        
        //4.flutter controller
        self.flutterViewController = FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
        
        //5. flutter channel
        self.mapChannel = FlutterMethodChannel(name: "net.nextome.phoenix",
                                              binaryMessenger: flutterViewController!.binaryMessenger)
        
        //MARK: Nextome init
        //1.start Nextome framework
        self.sdk = NextomeSdk()
        self.sdk?.enableParticleEngine = false
    
        //position observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceivePosition(_:)), name: NSNotification.Name(rawValue: "POSITION_STREAM"), object: nil)
        
        //path observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceivePath(_:)), name: NSNotification.Name(rawValue: "PATH_STREAM"), object: nil)
        
        //floor observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveFloorChange(_:)), name: NSNotification.Name(rawValue: "FLOOR_CHANGE"), object: nil)
        
        //outdoor observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveOutdoor(_:)), name: NSNotification.Name(rawValue: "OUTDOOR_STREAM"), object: nil)
        
        //error observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveError(_:)), name: NSNotification.Name(rawValue: "ERROR"), object: nil)
        
    }
    
    //MARK: MAP Position observer
    @objc func onDidReceivePosition(_ notification: Notification){
        //receive position
        let positionData = notification.userInfo as? [String : [String: Any]]
        
        //start map
        if flutterViewController?.viewIfLoaded?.window == nil{
            
            //hide loading
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Entering venue:  \(positionData!["positionData"]!["map"] as! Int)")
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.5) { success in
            }
            
            //push flutter controller
            let root  = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
            
            root.pushViewController(self.flutterViewController!, animated: true)
            
            self.initFlutterControllerDesign()

            //show POI
            let poiData = self.sdk?.getPOIData()
            mapChannel.invokeMethod("POI", arguments: poiData)
             
            //show mapview
            let data = self.sdk?.getVenueData()
            mapChannel.invokeMethod("localPackageUrl", arguments: data)
            
            //poiData callback
            mapChannel.setMethodCallHandler{(call: FlutterMethodCall, result: FlutterResult) -> Void in
                // Handle poi json
                  guard call.method == "poiData" else {
                    result(FlutterMethodNotImplemented)
                    return
                  }
                
                //calculate path
                self.sdk?.calculatePath_ToPOI(poi: call.arguments as? String)

            }

        }else{
        
            //map update
            let x = positionData!["positionData"]!["x"] as! String
            let y = positionData!["positionData"]!["y"] as! String
            
            self.mapChannel.invokeMethod("position", arguments: x + "," + y)
        }
        
        
        //MARK: new methods (sdk 1.3.1)
        //sdk status
        var status = self.sdk?.getSdkState()
        //venue resources
        var resource = self.sdk?.getVenueResources()

    }
    
    //MARK: FLoor observer
    @objc func onDidReceiveFloorChange(_ notification: Notification){
        //receive position
        let floorData = notification.userInfo as? [String : [String: Any]]
        
        //advise ui
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Floor is changed: \(floorData!["floorData"]!["floor"] as! Int)")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
        }
        
        //update package
        let data = self.sdk?.getVenueData()
        mapChannel.invokeMethod("localPackageUrl", arguments: data)
        
        //update poi
        let poiData = self.sdk?.getPOIData()
        mapChannel.invokeMethod("POI", arguments: poiData)

    }
    
    //MARK: MAP Path observer
    @objc func onDidReceivePath(_ notification: Notification){
        
        //receive path
        let pathData = notification.userInfo as? [String : String]
        
        if(pathData!["pathData"] != nil){
            self.mapChannel.invokeMethod("path", arguments: pathData!["pathData"]!)
        }
    }
    
    //MARK: Outdoor stream
    @objc func onDidReceiveOutdoor(_ notification: Notification){
        
        //receive position
        let positionData = notification.userInfo as? [String : Double]
        
        let lat = positionData!["lat"]!
        let lng = positionData!["lng"]!
        
        if MapViewController().viewIfLoaded?.window == nil{
            //push flutter controller
            let root  = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
            
            root.present(MapViewController(), animated: true)
        }

        
        //LOG WRITER
        print("SDK Outdoor -> lat: \(lat) \n lng: \(lng)")
        //MARK: LOG STREAM
        NotificationCenter.default.post(name: Notification.Name("LOG_WRITER"), object: nil, userInfo: ["log": "Outdoor -> lat: \(lat) \n lng: \(lng)"])
        

    }
    
    //MARK: Error observer
    @objc func onDidReceiveError(_ notification: Notification){
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
        self.sdk?.stop()
        
        //receive position
        let error = notification.userInfo as? [String : String]
        
        //advise ui
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Error: \(error!["error"] ?? "").")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 5.0) { success in
        }
    }
    
    
    //flutter controlller design init
    func initFlutterControllerDesign(){
         //show navigationbar
         flutterViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
         
         //add menu icon
         //create a new button
         let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
         //set image for button
         button.setImage(UIImage(named: "menu.png"), for: UIControl.State.normal)
         //add function for button
         button.addTarget(self, action:  #selector(self.menuPressed(_:)), for: UIControl.Event.touchUpInside)
         //set frame
         button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)

         let barButton = UIBarButtonItem(customView: button)
         //assign left menu button to navigationbar
         flutterViewController!.navigationItem.leftBarButtonItem = barButton
        
        let buttonReset: UIButton = UIButton(type: UIButton.ButtonType.custom)
        buttonReset.setTitle("Reset Path", for: .normal)
        //add function for button
        buttonReset.addTarget(self, action:  #selector(self.resetPath(_:)), for: UIControl.Event.touchUpInside)
        //set frame
        buttonReset.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let barButtonReset = UIBarButtonItem(customView: buttonReset)
        flutterViewController!.navigationItem.rightBarButtonItem = barButtonReset
         
         //assign title
         flutterViewController!.title = "Indoor Mapview"
         flutterViewController!.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "TitilliumWeb-Light", size: 20)!]
         flutterViewController!.navigationController!.navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }

    @objc func resetPath(_ sender:UITapGestureRecognizer) {
        
        //reset sdk poi
        self.sdk?.calculatePath_ToPOI(poi: nil)
        
        //reset map path
        self.mapChannel.invokeMethod("path", arguments: "[]")
        
        //This method will call when you press button.
        //advise ui
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Path reset complete")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
        }
    }
    
    //This method will call when you press button.
    @objc func menuPressed(_ sender:UITapGestureRecognizer) {

        // Define the menu
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let leftMenuController : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "leftMenuController") as! SideMenuNavigationController
        
        let root  = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
        
        root.present(leftMenuController, animated: true)
    }
    
    // MARK: UISceneSession Lifecycle

    override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


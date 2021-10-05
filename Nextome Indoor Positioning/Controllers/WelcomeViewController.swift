//
//  WelcomeViewController.swift
//  Nextome Indoor Positioning
//
//  Created by Francesco Paolo Dellaquila on 18/06/2020.
//  Copyright © 2020 Nextome. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PhoenixSdk
import Flutter

class WelcomeViewController: UIViewController, NVActivityIndicatorViewable {

    //View Components
    @IBOutlet weak var swipeUpArrow: UIImageView!
    
    //flutter map
    var flutterViewController: FlutterViewController?
    
    var firstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()

    }
    
    private func commonInit(){
        //disable navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = NSNumber(value: 0.0)
        anim.fromValue = NSNumber(value: Double.pi / 16) // rotation angle
        anim.duration = 0.1
        anim.repeatCount = Float(UInt.max)
        anim.autoreverses = true
        swipeUpArrow.layer.add(anim, forKey: "swipe up")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //stop sdk
        (UIApplication.shared.delegate as? AppDelegate)?.sdk!.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(firstLaunch){
            //save offline settings
            let defaults = UserDefaults.standard
            defaults.set("sdkMode", forKey: ((UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode)!)
            defaults.set("logEnabled", forKey: String(((UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog)!))
            defaults.set("particleEnabled", forKey: String(((UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine)!))
            defaults.synchronize()
        }else{
            let defaults = UserDefaults.standard
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode = defaults.string(forKey: "sdkMode") ?? "BLE"
            if(defaults.string(forKey: "particleEnabled") == nil){
                (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine =  true
            }else{
                (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine = Bool(defaults.string(forKey: "particleEnabled")!)!
            }
            if(defaults.string(forKey: "logEnabled") == nil){
                (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog = true
            }else{
                (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog = Bool(defaults.string(forKey: "logEnabled")!)!
            }
        }
    }
    
    @objc func didSwipe(_ sender: Any) {
        
        //start loading screen
        let frameView = CGRect(x: view.center.x, y: view.center.y, width: 10, height: 10)
        
        let animationTypeLabel = UILabel(frame: frameView)
        
        self.view.addSubview(animationTypeLabel)
        
        let size = CGSize(width: 40, height: 40)
        
        if((UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode == "BLE"){
            //freze arrow
            self.swipeUpArrow.layer.removeAllAnimations()
            
            startAnimating(size, message: "Searching Venue BLE...", type: NVActivityIndicatorType.ballScaleRippleMultiple)
            
            //start BLE localization
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.start()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Download Venue Resources...")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Load assets and init map...")
            }
            
            
        }else{
            
            //freze arrow
            self.swipeUpArrow.layer.removeAllAnimations()
            
            startAnimating(size, message: "Searching Venue GPS...", type: NVActivityIndicatorType.ballScaleRippleMultiple)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                

                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let gpsController = storyBoard.instantiateViewController(withIdentifier: "gpsController") as! UINavigationController
                
                gpsController.modalPresentationStyle = .fullScreen
                self.present(gpsController, animated: true, completion: nil)
            }
            
        

        }
                
    }
}

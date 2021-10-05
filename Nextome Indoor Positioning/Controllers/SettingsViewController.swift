//
//  SettingsViewController.swift
//  PhoenixSample
//
//  Created by Francesco Paolo Dellaquila on 03/09/2020.
//  Copyright © 2020 Nextome. All rights reserved.
//

import UIKit
import PhoenixSdk
import PKHUD

class SettingsViewController: UIViewController {


    
    //nextome sdk
    @IBOutlet weak var sdkMode: UISegmentedControl!
    @IBOutlet weak var particleEnabled: UISegmentedControl!
    @IBOutlet weak var logEnabled: UISegmentedControl!
    
    @IBOutlet weak var versionSystem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (UIApplication.shared.delegate as? AppDelegate)?.sdk!.stop()
    
        commonInit()
        
    }
    
    private func commonInit(){
        //set version system
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        versionSystem.text! = "version: " + (nsObject as! String)
        
        //set segmented controller sdk mode
        if((UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode == "BLE"){
            self.sdkMode.selectedSegmentIndex = 0
        }else{
            self.sdkMode.selectedSegmentIndex = 1
        }
        
        //set segmented controller particle
        if((UIApplication.shared.delegate as? AppDelegate)!.sdk!.enableParticleEngine){
            self.particleEnabled.selectedSegmentIndex = 0
        }else{
            self.particleEnabled.selectedSegmentIndex = 1
        }
        
        //set segmented controller log
        if((UIApplication.shared.delegate as? AppDelegate)!.sdk!.enableSendLog){
            self.logEnabled.selectedSegmentIndex = 0
        }else{
            self.logEnabled.selectedSegmentIndex = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set((UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode, forKey: "sdkMode")
        defaults.set((UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine, forKey: "particleEnabled")
        defaults.set((UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog, forKey: "logEnabled")
        defaults.synchronize()
        
        //hide loading
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Settings are changed. Restart sdk")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.5) { success in
        }
    }

    
    @IBAction func onSdkModeChange(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        switch sender.selectedSegmentIndex
        {
        case 0:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode = "BLE"
            defaults.set("BLE", forKey: "sdkMode")
            defaults.synchronize()
        case 1:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.sdkMode = "GPS"
            defaults.set("GPS", forKey: "sdkMode")
            defaults.synchronize()
        default:
            break
        }
    }
    
    
    @IBAction func onParticleEngineChange(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        switch sender.selectedSegmentIndex
        {
        case 0:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine = true
            defaults.set("True", forKey: "particleEnabled")
            defaults.synchronize()
        case 1:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableParticleEngine = false
            defaults.set("False", forKey: "particleEnabled")
            defaults.synchronize()
        default:
            break
        }
    }
    
    @IBAction func onLogChange(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        switch sender.selectedSegmentIndex
        {
        case 0:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog = true
            defaults.set("True", forKey: "logEnabled")
            defaults.synchronize()
        case 1:
            (UIApplication.shared.delegate as? AppDelegate)?.sdk!.enableSendLog = false
            defaults.set("False", forKey: "logEnabled")
            defaults.synchronize()
        default:
            break
        }
    }
    
    
    @IBAction func sendLogReport(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.sdk!.sendLogReport(context: self)
    }
    
}

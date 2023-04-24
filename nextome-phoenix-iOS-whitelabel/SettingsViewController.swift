//
//  SettingsViewController.swift
//  iosApp
//
//  Created by Anna Labellarte on 11/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import PhoenixSdk

class SettingsViewController: UIViewController {

    @IBOutlet weak var scanPeriodTextField: NTMTextField!
    @IBOutlet weak var betweenScanPeriodTextField: NTMTextField!
    @IBOutlet weak var rssiTrasholdTextField: NTMTextField!
    @IBOutlet weak var eventTimeoutTextField: NTMTextField!
    @IBOutlet weak var detectionFilterPicker: NTMTextFieldPicker!
    @IBOutlet weak var positionFilterPicker: NTMTextFieldPicker!
    
    
    @IBOutlet weak var sendAssetBeaconPicker: NTMTextFieldPicker!
    @IBOutlet weak var sendPositionPicker: NTMTextFieldPicker!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!

    @IBOutlet weak var debugUpdateIcon: UIImageView!
    @IBOutlet weak var debugModeSwitch: UISwitch!
    
    let viewmodel = SettingsViewModel()
    var type: SettingsType = .LOGIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.initViewModel(withType: type)
        
        setupViews()
        setupInitialData()

        
    }
    
    func setupViews(){
        detectionFilterPicker.setOptions([L10n.settingsDefault])
        positionFilterPicker.setOptions([L10n.settingsDefault])
        
        let switchOptions = [L10n.settingsDefault, L10n.genericYes, L10n.genericNo]
        sendAssetBeaconPicker.setOptions(switchOptions)
        sendPositionPicker.setOptions(switchOptions)
    }
    
    func setupInitialData(){
        let settings = viewmodel.settingsUI
        scanPeriodTextField.defaultValue = settings.scanPeriodDefault
        scanPeriodTextField.value = settings.scanPeriod
        scanPeriodTextField.isEnabled = settings.isEditable
        
        betweenScanPeriodTextField.defaultValue = settings.betweenScanPeriodDefault
        betweenScanPeriodTextField.value = settings.betweenScanPeriod
        betweenScanPeriodTextField.isEnabled = settings.isEditable

        rssiTrasholdTextField.defaultValue = settings.rssiThresholdDefault
        rssiTrasholdTextField.value = settings.rssiThreshold
        rssiTrasholdTextField.isEnabled = settings.isEditable

        eventTimeoutTextField.defaultValue = settings.eventTimeoutDefault
        eventTimeoutTextField.value = settings.eventTimeout
        eventTimeoutTextField.isEnabled = settings.isEditable

        detectionFilterPicker.defaultValue = L10n.settingsDefault
        detectionFilterPicker.value = nil
        detectionFilterPicker.isEnabled = settings.isEditable
        detectionFilterPicker.isHidden = true
        
        positionFilterPicker.defaultValue = L10n.settingsDefault
        positionFilterPicker.value = nil
        positionFilterPicker.isEnabled = settings.isEditable
        positionFilterPicker.isHidden = true

        sendAssetBeaconPicker.defaultValue = settings.isSendAssetsToServerEnabledDefault
        sendAssetBeaconPicker.value = settings.isSendAssetsToServerEnabled
        sendAssetBeaconPicker.isEnabled = settings.isEditable

        sendPositionPicker.defaultValue = settings.isSendPositionToServerEnabledDefault
        sendPositionPicker.value = settings.isSendPositionToServerEnabled
        sendPositionPicker.isEnabled = settings.isEditable

        debugModeSwitch.isOn = settings.isDebugModeEnabled
        debugModeSwitch.isEnabled = settings.isEditable
        debugUpdateIcon.isHidden = !settings.isDebugModeEnabled
        
        restoreButton.isHidden = !settings.isEditable
        saveButton.isHidden = !settings.isEditable

    }
    
    
    
    @IBAction func onRestoreClicked(_ sender: Any) {
        viewmodel.restoreData()
        setupInitialData()
    }
    @IBAction func onSaveClicked(_ sender: Any) {
        let scanPeriod = scanPeriodTextField.value
        let betweenScanPeriod = betweenScanPeriodTextField.value
        let rssiTrashold = rssiTrasholdTextField.value
        let eventTimeout = eventTimeoutTextField.value
        let sendAssetBeacon = sendAssetBeaconPicker.value
        let sendPositionBeacon = sendPositionPicker.value
        let isDebugModeEnabled = debugModeSwitch.isOn
        
        let updateSettings = NextomeSettingsUI(scanPeriod: scanPeriod, betweenScanPeriod: betweenScanPeriod, rssiThreshold: rssiTrashold,eventTimeout: eventTimeout, isSendPositionToServerEnabled: sendPositionBeacon, isSendAssetsToServerEnabled: sendAssetBeacon, isDebugModeEnabled: isDebugModeEnabled
        )
        viewmodel.save(uiData: updateSettings)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onDebugValueChanged(_ sender: Any) {
        debugUpdateIcon.isHidden = !debugModeSwitch.isOn
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    enum SettingsType{
        case LOGIN, MAP(venueSettings: NextomeSettings?)
    }
}

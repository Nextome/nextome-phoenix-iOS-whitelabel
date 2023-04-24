// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Beacon list max size
  internal static let beaconListMaxSize = L10n.tr("Localizable", "beacon_list_max_size", fallback: "Beacon list max size")
  /// RSSI Threshold
  internal static let beaconRssiThreshold = L10n.tr("Localizable", "beacon_rssi_threshold", fallback: "RSSI Threshold")
  /// Scanning in progress…
  internal static let beaconsEmpty = L10n.tr("Localizable", "beacons_empty", fallback: "Scanning in progress…")
  /// Between Scan Period
  internal static let betweenScanPeriod = L10n.tr("Localizable", "between_scan_period", fallback: "Between Scan Period")
  /// The bluetooth is disabled. Be sure to enable it before entering the app
  internal static let btDisabledMessage = L10n.tr("Localizable", "bt_disabled_message", fallback: "The bluetooth is disabled. Be sure to enable it before entering the app")
  /// Bluetooth disabled
  internal static let btDisabledTitle = L10n.tr("Localizable", "bt_disabled_title", fallback: "Bluetooth disabled")
  /// Change user
  internal static let changeUser = L10n.tr("Localizable", "change_user", fallback: "Change user")
  /// There are no apps asssociated to this developer account.
  internal static let errorNoApps = L10n.tr("Localizable", "error_no_apps", fallback: "There are no apps asssociated to this developer account.")
  /// EXIT NAVIGATION
  internal static let exitNavigation = L10n.tr("Localizable", "exit_navigation", fallback: "EXIT NAVIGATION")
  /// Cancel
  internal static let genericCancel = L10n.tr("Localizable", "generic_cancel", fallback: "Cancel")
  /// No
  internal static let genericNo = L10n.tr("Localizable", "generic_no", fallback: "No")
  /// Ok
  internal static let genericOk = L10n.tr("Localizable", "generic_ok", fallback: "Ok")
  /// Yes
  internal static let genericYes = L10n.tr("Localizable", "generic_yes", fallback: "Yes")
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "loading", fallback: "Loading...")
  /// Without location permissions the localization will not be available
  internal static let locationPermissionDisabledMessage = L10n.tr("Localizable", "location_permission_disabled_message", fallback: "Without location permissions the localization will not be available")
  /// Permissions restricted
  internal static let locationPermissionDisabledTitle = L10n.tr("Localizable", "location_permission_disabled_title", fallback: "Permissions restricted")
  /// Email
  internal static let loginEmail = L10n.tr("Localizable", "login_email", fallback: "Email")
  /// Enter
  internal static let loginEnter = L10n.tr("Localizable", "login_enter", fallback: "Enter")
  /// en.strings
  ///   iosApp
  /// 
  ///   Created by Anna Labellarte on 17/11/22.
  ///   Copyright © 2022 orgName. All rights reserved.
  internal static let loginFieldError = L10n.tr("Localizable", "login_field_error", fallback: "Please fill all the fields")
  /// Password
  internal static let loginPassword = L10n.tr("Localizable", "login_password", fallback: "Password")
  /// Save credentials
  internal static let loginSaveCredentials = L10n.tr("Localizable", "login_save_credentials", fallback: "Save credentials")
  /// Logout
  internal static let menuLogout = L10n.tr("Localizable", "menu_logout", fallback: "Logout")
  /// Show POI LIST
  internal static let menuShowPoi = L10n.tr("Localizable", "menu_showPoi", fallback: "Show POI LIST")
  /// Show SETTINGS
  internal static let menuShowSettings = L10n.tr("Localizable", "menu_showSettings", fallback: "Show SETTINGS")
  /// No network available, please try later.
  internal static let noNetwork = L10n.tr("Localizable", "no_network", fallback: "No network available, please try later.")
  /// Nextome Test App will NOT work in background
  internal static let permissionBackgroundDeniedRationale = L10n.tr("Localizable", "permission_background_denied_rationale", fallback: "Nextome Test App will NOT work in background")
  /// Please accept permissions to use Nextome Test app
  internal static let permissionDeniedRationale = L10n.tr("Localizable", "permission_denied_rationale", fallback: "Please accept permissions to use Nextome Test app")
  /// Location permissions are disabled, allow access to location before continuing
  internal static let requireLocationPermissionMessage = L10n.tr("Localizable", "require_location_permission_message", fallback: "Location permissions are disabled, allow access to location before continuing")
  /// Allow the app to access the location
  internal static let requireLocationPermissionTitle = L10n.tr("Localizable", "require_location_permission_title", fallback: "Allow the app to access the location")
  /// Scan period
  internal static let scanPeriod = L10n.tr("Localizable", "scan_period", fallback: "Scan period")
  /// Additional features
  internal static let settingsAdditionalFeatures = L10n.tr("Localizable", "settings_additionalFeatures", fallback: "Additional features")
  /// Algorithm parameters
  internal static let settingsAlgorithmParameterLabel = L10n.tr("Localizable", "settings_algorithmParameterLabel", fallback: "Algorithm parameters")
  /// App settings
  internal static let settingsAppSection = L10n.tr("Localizable", "settings_appSection", fallback: "App settings")
  /// Between scan period (millis)
  internal static let settingsBetweenScanPeriod = L10n.tr("Localizable", "settings_betweenScanPeriod", fallback: "Between scan period (millis)")
  /// Debug mode
  internal static let settingsDebugMode = L10n.tr("Localizable", "settings_debugMode", fallback: "Debug mode")
  /// Default
  internal static let settingsDefault = L10n.tr("Localizable", "settings_default", fallback: "Default")
  /// Filter on detections
  internal static let settingsDetectionsFilter = L10n.tr("Localizable", "settings_detectionsFilter", fallback: "Filter on detections")
  /// Events time out(millis)
  internal static let settingsEventTimeout = L10n.tr("Localizable", "settings_eventTimeout", fallback: "Events time out(millis)")
  /// Filter on positions
  internal static let settingsPositionsFilter = L10n.tr("Localizable", "settings_positionsFilter", fallback: "Filter on positions")
  /// Restore
  internal static let settingsRestore = L10n.tr("Localizable", "settings_restore", fallback: "Restore")
  /// RSSI threshold (db)
  internal static let settingsRssiFilter = L10n.tr("Localizable", "settings_rssiFilter", fallback: "RSSI threshold (db)")
  /// Save
  internal static let settingsSave = L10n.tr("Localizable", "settings_save", fallback: "Save")
  /// Scan period (millis)
  internal static let settingsScanPeriod = L10n.tr("Localizable", "settings_scanPeriod", fallback: "Scan period (millis)")
  /// Send asset beacon to server
  internal static let settingsSendAssetBeacon = L10n.tr("Localizable", "settings_sendAssetBeacon", fallback: "Send asset beacon to server")
  /// Send position to server
  internal static let settingsSendAssetPosition = L10n.tr("Localizable", "settings_sendAssetPosition", fallback: "Send position to server")
  /// Advanced settings
  internal static let settingsTitle = L10n.tr("Localizable", "settings_title", fallback: "Advanced settings")
  /// MODIFY ONLY IN ACCORDANCE WITH THE NEXTOME TEAM
  internal static let settingsUpdateAlert = L10n.tr("Localizable", "settings_updateAlert", fallback: "MODIFY ONLY IN ACCORDANCE WITH THE NEXTOME TEAM")
  /// Welcome back
  internal static let splashWelcomeBack = L10n.tr("Localizable", "splash_welcome_back", fallback: "Welcome back")
  /// STOP
  internal static let stop = L10n.tr("Localizable", "stop", fallback: "STOP")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

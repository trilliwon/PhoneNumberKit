
import Foundation

private class CurrentBundleFinder {}

// The custom bundle locator code is needed to work around a bug in Xcode
// where SwiftUI previews in an SPM module will crash if they try to use
// resources in another SPM module that are loaded using the synthesized
// Bundle.module accessor.
//
extension Bundle {
    static var appModule: Bundle? = {
        let bundleName = "PhoneNumberKit_PhoneNumberKit"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        return nil
    }()
}

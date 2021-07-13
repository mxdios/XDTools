//
//  BundleEx.swift
//  inspos
//
//  Created by miaoxiaodong on 2020/8/12.
//  Copyright © 2020 inspiry. All rights reserved.
//

import UIKit

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.getLanguageBundel() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
extension Bundle {
    private static var onLanguageDispatchOnce: ()->Void = {
        object_setClass(Bundle.main, BundleEx.self)
    }
    func onLanguage(){
        Bundle.onLanguageDispatchOnce()
    }
    
    class func getLanguageBundel() -> Bundle? {
        let language = getAppLanguage()
        let lproj = Bundle.main.path(forResource: language, ofType: "lproj")
        guard lproj != nil else {
            return nil
        }
        let languageBundle = Bundle.init(path: lproj!)
        guard languageBundle != nil else {
            return nil
        }
        return languageBundle!
        
    }
}

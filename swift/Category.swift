//
//  Category.swift
//  inspos
//
//  Created by miaoxiaodong on 2020/7/1.
//  Copyright © 2020 inspiry. All rights reserved.
//

import UIKit

extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var temp = self.frame
            temp.size.width = newValue
            self.frame = temp
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var temp = self.frame
            temp.size.height = newValue
            self.frame = temp
        }
    }
    
    public var size:CGSize {
        get {
            return self.frame.size
        }
        set {
            var temp = self.frame
            temp.size = newValue
            self.frame = temp
        }
    }
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var temp = self.center
            temp.x = newValue
            self.center = temp
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var temp = self.center
            temp.y = newValue
            self.center = temp
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
}


extension UIImage {
    /// 拉伸图片
    class func pullImage(imgName: String) -> UIImage {
        return pullImage(imageName: imgName, leftRatio: 0.5, topRatio: 0.5)
    }
    class func pullImage(imageName: String, leftRatio: CGFloat, topRatio: CGFloat) -> UIImage {
        if imageName.count == 0 {
            return UIImage()
        }
        if let pullImg = UIImage(named: imageName) {
            let left = pullImg.size.width * leftRatio
            let top = pullImg.size.height * topRatio
            return pullImg.stretchableImage(withLeftCapWidth: Int(left), topCapHeight: Int(top))
        } else {
            return UIImage()
        }
    }
    /// 图片设置纯颜色
    func setColor(color: UIColor) -> UIImage {
        let imageRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.scaleBy(x: 1.0, y: -1.0);
        context.translateBy(x: 0.0, y: -(size.height))
        context.clip(to: imageRect, mask: self.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}

extension String {
    /// jwt解析
    func jwtDecode () -> [String: Any]? {
        /**分割为数组*/
        let segments = components(separatedBy: ".")
        /**获取第二个元素Payload负载元素(有意义的key就在里面解析的)*/
        var base64String = segments[1]
        /** base64解码*/
        let requiredLength = (4 * ceil((Float)(base64String.count)/4.0))
        let nbrPaddings = Int(requiredLength) - base64String.count
        if nbrPaddings > 0 {
            let pading = "".padding(toLength: nbrPaddings,withPad: "=",startingAt: 0)
            base64String = base64String + pading
        }
        base64String = base64String.replacingOccurrences(of: "-",with: "+")
        base64String = base64String.replacingOccurrences(of: "_",with: "/")
        let decodeData = Data(base64Encoded: base64String,options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodeString = String.init(data: decodeData!,encoding: String.Encoding.utf8)
        /**转为字典*/
        let jsonDict:[String : Any]? = try? JSONSerialization.jsonObject(with:(decodeString?.data(using: String.Encoding.utf8))!,options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
        /**返回jwt */
        return jsonDict
    }
    /// 添加千分位分隔符
    var thousandsLevel: String {
        if Int(self) == nil {
            return self
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formStr = formatter.string(for: Int(self)) {
            return formStr
        }
        return self
    }
    /// 多语言
    var localized: String {
        let language = getAppLanguage()
        if language != nil {
            let lproj = Bundle.main.path(forResource: language!, ofType: "lproj")
            let bundle = Bundle.init(path: lproj!)
            if bundle != nil {
                return bundle!.localizedString(forKey: self, value: self, table: "Localizable")
            } else {
                return NSLocalizedString(self, comment: self)
            }
        } else {
            return NSLocalizedString(self, comment: self)
        }
    }
    /// emoji相关的判断
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    var containsEmoji: Bool { contains { $0.isEmoji } }
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    var emojis: [Character] { filter { $0.isEmoji } }
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

//十六进制颜色转换
extension UIColor {
    /// Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
/// 导航返回协议
@objc protocol NavigationProtocol {
    /// 导航将要返回方法
    ///
    /// - Returns: true: 返回上一界面， false: 禁止返回
    @objc optional func navigationShouldPopMethod() -> Bool
}
 
extension UIViewController: NavigationProtocol {
    func navigationShouldPopMethod() -> Bool {
        return true
    }
}
 
extension NavViewController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
     
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        var shouldPop = false
        let vc: UIViewController = topViewController!
        if vc.responds(to: #selector(navigationShouldPopMethod)) {
            shouldPop = vc.navigationShouldPopMethod()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
     
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        } else {
            if topViewController?.responds(to: #selector(navigationShouldPopMethod)) != nil {
                return topViewController!.navigationShouldPopMethod()
            }
            return true
        }
    }
}

/// 修复拍照切割时不可拖动到边的系统bug
extension UIImagePickerController {
    func fixCannotMoveEditingBox() {
        if let cropView = cropView,
           let scrollView = scrollView,
           scrollView.contentOffset.y == 0 {
            let top = cropView.frame.minY //+ self.view.safeAreaInsets.top
            let bottom = scrollView.frame.height - cropView.frame.height - top
            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
            
            var offset: CGFloat = 0
            if scrollView.contentSize.height > scrollView.contentSize.width {
                offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
            }
            scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fixCannotMoveEditingBox()
        }
    }
    
    var cropView: UIView? {
        return findCropView(from: self.view)
    }
    
    var scrollView: UIScrollView? {
        return findScrollView(from: self.view)
    }
    
    func findCropView(from view: UIView) -> UIView? {
        let width = UIScreen.main.bounds.width
        let size = view.bounds.size
        if width == size.height, width == size.height {
            return view
        }
        for view in view.subviews {
            if let cropView = findCropView(from: view) {
                return cropView
            }
        }
        return nil
    }
    
    func findScrollView(from view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for view in view.subviews {
            if let scrollView = findScrollView(from: view) {
                return scrollView
            }
        }
        return nil
    }
}

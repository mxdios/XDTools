//
//  XDTools.swift
//  mremind
//
//  Created by miaoxiaodong on 2017/12/6.
//  Copyright © 2017年 mark. All rights reserved.
//

import UIKit
import KeychainAccess
import CoreTelephony

/// 自定义print
func XDLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    print("\(file):(\(lineNum)):\(message)");
    #endif
}
/// view的宽
let XDViewWidth = UIScreen.main.bounds.size.width
/// view的高
let XDViewHeight = UIScreen.main.bounds.size.height
/// 是否是iPad
func isiPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
/// 判断字符串是否为空和全是空格
func stringIsEmpty(str: String) -> Bool {
    if str.count == 0 {
        return true
    } else {
        let set = NSCharacterSet.whitespacesAndNewlines
        let trimedStr = str.trimmingCharacters(in: set)
        if trimedStr.count == 0 {
            return true
        } else {
            return false
        }
    }
}
/// 字典转字符串
func dicValueString(_ dic:[String : Any]) -> String?{
    let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}
/// 字符串转字典
func stringValueDic(_ str: String) -> [String : Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
        return dict
    }
    return nil
}
/// 自定义颜色
func XDAlpColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
/// 随机色
func XDRandomColor() -> UIColor {
    let r = CGFloat(arc4random_uniform(255) + 1)
    let g = CGFloat(arc4random_uniform(255) + 1)
    let b = CGFloat(arc4random_uniform(255) + 1)
    return XDAlpColor(r: r, g: g, b: b, a: 1)
}
/// 随机位数的字符串
func XDRandomStr(len: Int) -> String {
    var ranStr = ""
    let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for _ in 0..<len {
        let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
        ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
    }
    return ranStr
}
/// 手机号正则
func isPhoneNumber(num:String) -> Bool {
    if num.count == 0 {
        return false
    }
    let mobile = "^1[3-9]\\d{9}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    return regexMobile.evaluate(with: num)
}
/// 邮箱正则
func isEmail(email: String) -> Bool {
    if email.count == 0 {
        return false
    }
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}
/// 数字或字母的字符串正则
func isNumAlphabet(str: String) -> Bool {
    let strRegex = "^[A-Za-z0-9]+$"
    let strTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", strRegex)
    return strTest.evaluate(with: str)
}
/// 纯数字字符串正则
func isNum(str: String) -> Bool {
    let strRegex = "^[0-9]+$"
    let strTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", strRegex)
    return strTest.evaluate(with: str)
}
/// 英文+数字+指定字符的密码正则
func isPwdStr(str: String) -> Bool {
    if str.count == 0 {
        return false
    }
    let strRegex = "^[a-zA-Z-z0-9`~!@#$%^+&*/?|:.<>{}()\"\\[\\]\\\\]+$" //英文，数字, 特殊字符：`~!@#$%^+&*/?|:.<>{}()"[]\
    let strTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", strRegex)
    return strTest.evaluate(with: str)
}
/// 设置AttributedText方法
func setupAttributedText(text: String, startArray: Array<Any>, endArray: Array<Any>) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(string: text)
    let startLength = startArray[0] as! Int
    let endLength = endArray[0] as! Int
    
    let startRange = NSRange(location: 0, length: startLength > 0 ? startLength : text.count - endLength)
    let endRange = NSRange(location: startLength > 0 ? startLength : text.count - endLength, length: endLength > 0 ? endLength : text.count - startLength)
    //颜色
    str.addAttribute(.foregroundColor, value: startArray[1], range: startRange)
    str.addAttribute(.foregroundColor, value: endArray[1], range: endRange)
    //字号
    str.addAttribute(.font, value: startArray[2], range: startRange)
    str.addAttribute(.font, value: endArray[2], range: endRange)
    return str
}
/// 设置多个attrubutedText方法
func setupAttText(text: String, section: (count: Int, color: UIColor, font: UIFont)...) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(string: text)
    var locationInn = 0
    for item in section {
        str.addAttribute(.foregroundColor, value: item.color, range: NSRange(location: locationInn, length: item.count))
        str.addAttribute(.font, value: item.font, range: NSRange(location: locationInn, length: item.count))
        locationInn += item.count
    }
    return str
}
/// UUID+钥匙串获取app唯一标识
func getAppUniqueIdentifier() -> String {
    let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    let keychain = Keychain(service: bundleId)
    if let appid = keychain["AppUniqueIdentifier"] {
        return appid
    } else {
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        keychain["AppUniqueIdentifier"] = uuid
        return uuid
    }
}
/// 获取手机型号，更新至iPhone 12
func getiPhoneModelName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let platform = String(cString: &systemInfo.machine.0, encoding: .utf8)
    if platform == nil {
        return UIDevice.current.model
    }
    switch platform {
    // 模拟器
    case "i386", "x86_64": return "iPhone Simulator"
    // iPhone
    case "iPhone13,4": return "iPhone 12 Pro Max"
    case "iPhone13,3": return "iPhone 12 Pro"
    case "iPhone13,2": return "iPhone 12"
    case "iPhone13,1": return "iPhone 12 mini"
    case "iPhone12,8": return "iPhone SE"
    case "iPhone12,5": return "iPhone 11 Pro Max"
    case "iPhone12,3": return "iPhone 11 Pro"
    case "iPhone12,1": return "iPhone 11"
    case "iPhone11,6", "iPhone11,4": return "iPhone XS Max"
    case "iPhone11,2": return "iPhone XS"
    case "iPhone11,8": return "iPhone XR"
    case "iPhone10,3", "iPhone10,6": return "iPhone X"
    case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
    case "iPhone10,1", "iPhone10,4": return "iPhone 8"
    case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
    case "iPhone9,1", "iPhone9,3": return "iPhone 7"
    case "iPhone8,4": return "iPhone SE"
    case "iPhone8,2": return "iPhone 6s Plus"
    case "iPhone8,1": return "iPhone 6s"
    case "iPhone7,1": return "iPhone 6 Plus"
    case "iPhone7,2": return "iPhone 6"
    case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
    case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
    case "iPhone5,1", "iPhone5,2": return "iPhone 5"
    case "iPhone4,1": return "iPhone 4S"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
    case "iPhone2,1": return "iPhone 3GS"
    case "iPhone1,2": return "iPhone 3G"
    case "iPhone1,1": return "iPhone"
    // iPad Pro
    case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro 5(12.9-inch)"
    case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro 3(11-inch)"
    case "iPad8,11", "iPad8,12": return "iPad Pro 4(12.9-inch)"
    case "iPad8,9", "iPad8,10": return "iPad Pro 2(11-inch)"
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 3(12.9-inch)"
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro(11-inch)"
    case "iPad7,3", "iPad7,4": return "iPad Pro(10.5-inch)"
    case "iPad7,1", "iPad7,2": return "iPad Pro 2(12.9-inch)"
    case "iPad6,3", "iPad6,4": return "iPad Pro(9.7-inch)"
    case "iPad6,7", "iPad6,8": return "iPad Pro(12.9-inch)"
    // iPad Air
    case "iPad13,1", "iPad13,2": return "iPad Air 4"
    case "iPad11,3", "iPad11,4": return "iPad Air 3"
    case "iPad5,3", "iPad5,4": return "iPad Air 2"
    case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
    // iPad mini
    case "iPad11,1", "iPad11,2": return "iPad mini 5"
    case "iPad5,1", "iPad5,2": return "iPad mini 4"
    case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad mini 3"
    case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad mini 2"
    case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad mini"
    // iPad
    case "iPad11,6", "iPad11,7": return "iPad 8"
    case "iPad7,11", "iPad7,12": return "iPad 7"
    case "iPad7,5", "iPad7,6": return "iPad 6"
    case "iPad6,11", "iPad6,12": return "iPad 5"
    case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
    case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
    case "iPad1,1": return "iPad"
    // iPod touch
    case "iPod9,1": return "iPod touch 7"
    case "iPod7,1": return "iPod touch 6"
    case "iPod5,1": return "iPod touch 5"
    case "iPod4,1": return "iPod touch 4"
    case "iPod3,1": return "iPod touch 3"
    case "iPod2,1": return "iPod touch 2"
    case "iPod1,1": return "iPod touch"
    default: return platform!
    }
}
/// 获取运营商
func getOperatorInfomation() -> String {
    let info = CTTelephonyNetworkInfo()
    if let carrier = info.subscriberCellularProvider {
        switch carrier.mobileNetworkCode {
        case "00", "02", "07": return "中国移动"
        case "01", "06", "09": return "中国联通"
        case "03", "05", "11": return "中国电信"
        default:
            return "-"
        }
    } else {
        return "-"
    }
}
//MARK: 图片相关
/// 返回透明图片
func getAlphaImage(alpha: CGFloat, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
    let ctx = UIGraphicsGetCurrentContext()
    let area = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    ctx!.scaleBy(x: 1, y: -1);
    ctx!.translateBy(x: 0, y: -area.size.height);
    ctx!.setBlendMode(.multiply)
    ctx!.setAlpha(alpha);
    ctx!.draw(image.cgImage!, in: area)
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage!;
}
/// 返回彩色图片
func XDImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    let content:CGContext = UIGraphicsGetCurrentContext()!
    content.setFillColor(color.cgColor)
    content.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

/// 生成二维码
func generateCode(inputMsg: String, fgImage: UIImage?) -> UIImage {
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setDefaults()
    filter?.setValue("H", forKey: "inputCorrectionLevel")
    let inputData = inputMsg.data(using: .utf8)
    filter?.setValue(inputData, forKey: "inputMessage")
    guard let outImage = filter?.outputImage else { return UIImage() }
    let hdImage = getHDImage(outImage)
    if fgImage == nil{
        return hdImage
    }
    return getResultImage(hdImage: hdImage, fgImage: fgImage!)
}
/// 获取高清图片
fileprivate func getHDImage(_ outImage: CIImage) -> UIImage {
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let ciImage = outImage.transformed(by: transform)
    return UIImage(ciImage: ciImage)
}
/// 获取前景图片
fileprivate func getResultImage(hdImage: UIImage, fgImage: UIImage) -> UIImage {
    let hdSize = hdImage.size
    UIGraphicsBeginImageContext(hdSize)
    hdImage.draw(in: CGRect(x: 0, y: 0, width: hdSize.width, height: hdSize.height))
    let fgWidth: CGFloat = 80
    fgImage.draw(in: CGRect(x: (hdSize.width - fgWidth) / 2, y: (hdSize.height - fgWidth) / 2, width: fgWidth, height: fgWidth))
    guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
    UIGraphicsEndImageContext()
    return resultImage
}
/// 压缩图片到指定大小
func resetSizeOfImageData(source_image: UIImage!, maxSize: Int) -> Data {
    //先判断当前质量是否满足要求，不满足再进行压缩
    var finallImageData = source_image.jpegData(compressionQuality: 1.0)
    let sizeOrigin      = finallImageData?.count
    let sizeOriginKB    = sizeOrigin! / 1024
    if sizeOriginKB <= maxSize {
        return finallImageData!
    }
    //先调整分辨率
    var defaultSize = CGSize(width: 1024, height: 1024)
    let newImage = newSizeImage(size: defaultSize, source_image: source_image)
    finallImageData = newImage.jpegData(compressionQuality: 1.0);
    //保存压缩系数
    let compressionQualityArr = NSMutableArray()
    let avg = CGFloat(1.0/250)
    var value = avg
    var i = 250
    repeat {
        i -= 1
        value = CGFloat(i)*avg
        compressionQualityArr.add(value)
    } while i >= 1
    //思路：使用二分法搜索
    finallImageData = halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
    //如果还是未能压缩到指定大小，则进行降分辨率
    while finallImageData?.count == 0 {
        //每次降100分辨率
        if defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0 {
            break
        }
        defaultSize = CGSize(width: defaultSize.width-100, height: defaultSize.height-100)
        let image = newSizeImage(size: defaultSize, source_image: UIImage.init(data: newImage.jpegData(compressionQuality: compressionQualityArr.lastObject as! CGFloat)!)!)
        finallImageData = halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: image.jpegData(compressionQuality: 1.0)!, maxSize: maxSize)
    }
    return finallImageData!
}

/// 调整图片分辨率/尺寸（等比例缩放）
func newSizeImage(size: CGSize, source_image: UIImage) -> UIImage {
    var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
    let tempHeight = newSize.height / size.height
    let tempWidth = newSize.width / size.width
    
    if tempWidth > 1.0 && tempWidth > tempHeight {
        newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
    } else if tempHeight > 1.0 && tempWidth < tempHeight {
        newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
    }
    
    UIGraphicsBeginImageContext(newSize)
    source_image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
/// 二分法压缩图片
func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
    var tempFinallImageData = finallImageData
    var tempData = Data.init()
    var start = 0
    var end = arr.count - 1
    var index = 0
    var difference = Int.max
    while start <= end {
        index = start + (end - start)/2
        tempFinallImageData = image.jpegData(compressionQuality: arr[index])!
        let sizeOrigin = tempFinallImageData.count
        let sizeOriginKB = sizeOrigin / 1024
        if sizeOriginKB > maxSize {
            start = index + 1
        } else if sizeOriginKB < maxSize {
            if maxSize-sizeOriginKB < difference {
                difference = maxSize-sizeOriginKB
                tempData = tempFinallImageData
            }
            if index<=0 {
                break
            }
            end = index - 1
        } else {
            break
        }
    }
    return tempData
}
//MARK: 时间相关
/// 获取时间戳
func getTimeStamp() -> TimeInterval {
    return Date().timeIntervalSince1970
}
/// 毫秒时间戳转date
func timeStampToDate(stamp: Double?) -> Date {
    if stamp == nil || stamp! == 0 {
        return Date()
    }
    let timeInterval = TimeInterval(exactly: stamp! / 1000)
    return Date(timeIntervalSince1970: timeInterval!)
}
/// 毫秒时间戳转时间字符串
func timeStampToTimeStr(stamp: Double?) -> String {
    if stamp == nil || stamp! == 0 {
        return "noknow".localized
    }
    let timeInterval = TimeInterval(exactly: stamp! / 1000)
    let date = Date(timeIntervalSince1970: timeInterval!)
    let dateForm = DateFormatter()
    dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateForm.string(from: date)
}
/// 年月日转date
func timeStrToDate (time: String) -> Date {
    let dateForm = DateFormatter()
    dateForm.dateFormat = "yyyy-MM-dd"
    return dateForm.date(from: time) ?? Date()
}
/// 年月日时分秒转date
func timeAllStrToDate (time: String) -> Date {
    let dateForm = DateFormatter()
    dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateForm.date(from: time) ?? Date()
}
/// date转年月日
func dateToTimeStr (date: Date) -> String {
    let dateForm = DateFormatter()
    dateForm.dateFormat = "yyyy-MM-dd"
    return dateForm.string(from: date)
}
/// 根据date获取年月日
func getDateComForDate (date: Date) -> DateComponents {
    let calendar = Calendar.current
    let dateComponets = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: date)
    return dateComponets
}
/// 获取type=0今天，type=1昨天，type=2近7天，type=3近1个月的时间
func getTimeStemp(type: Int) -> (leftTime: Int, rightTime: Int) {
    if type == 0 { //今天
        let rightStamp = getTimeStamp()
        let dayStr = dateToTimeStr(date: Date())
        let leftStamp = timeStrToDate(time: dayStr).timeIntervalSince1970
        return (Int(leftStamp * 1000), Int(rightStamp * 1000))
    } else if type == 1 {//昨天
        let nowStamp = getTimeStamp() - 24*60*60
        let date = Date(timeIntervalSince1970: nowStamp)
        let dateStr = dateToTimeStr(date: date)
        let leftStamp = timeStrToDate(time: dateStr).timeIntervalSince1970
        let rightStamp = timeAllStrToDate(time: (dateStr + " 23:59:59")).timeIntervalSince1970
        return (Int(leftStamp * 1000), Int(rightStamp * 1000 + 999))
    } else if type == 2 { //近7天
        // 包含今天
//        let rightStamp = getTimeStamp()
//        let nowStamp = rightStamp - 6*24*60*60
//        let date = Date(timeIntervalSince1970: nowStamp)
//        let dateStr = dateToTimeStr(date: date)
//        let leftStamp = timeStrToDate(time: dateStr).timeIntervalSince1970
//        return (Int(leftStamp * 1000), Int(rightStamp * 1000))
        // 不包含今天
        let nowStamp = getTimeStamp() - 24*60*60
        let date = Date(timeIntervalSince1970: nowStamp)
        let dateStr = dateToTimeStr(date: date)
        let rightStamp = timeAllStrToDate(time: (dateStr + " 23:59:59")).timeIntervalSince1970
        
        let leftStemp = nowStamp - 6*24*60*60
        let leftdate = Date(timeIntervalSince1970: leftStemp)
        let leftdateStr = dateToTimeStr(date: leftdate)
        let leftStamp = timeStrToDate(time: leftdateStr).timeIntervalSince1970
        return (Int(leftStamp * 1000), Int(rightStamp * 1000 + 999))
    } else if type == 3 { //近1个月
//        包含今天
//        let rightStamp = getTimeStamp()
//        let nowStamp = rightStamp - 29*24*60*60
//        let date = Date(timeIntervalSince1970: nowStamp)
//        let dateStr = dateToTimeStr(date: date)
//        let leftStamp = timeStrToDate(time: dateStr).timeIntervalSince1970
//        return (Int(leftStamp * 1000), Int(rightStamp * 1000))
        // 不包含今天
        let nowStamp = getTimeStamp() - 24*60*60
        let date = Date(timeIntervalSince1970: nowStamp)
        let dateStr = dateToTimeStr(date: date)
        let rightStamp = timeAllStrToDate(time: (dateStr + " 23:59:59")).timeIntervalSince1970
        
        let leftStemp = nowStamp - 29*24*60*60
        let leftdate = Date(timeIntervalSince1970: leftStemp)
        let leftdateStr = dateToTimeStr(date: leftdate)
        let leftStamp = timeStrToDate(time: leftdateStr).timeIntervalSince1970
        return (Int(leftStamp * 1000), Int(rightStamp * 1000 + 999))
    }
    return (0, 0)
}
/// 返回****手机号
func getEncryptPhone(num: String?) -> String {
    if num == nil {
        return ""
    } else {
        if num!.count < 11 {
            return num!
        } else {
            return num!.prefix(3) + "****" + num!.suffix(4)
        }
    }
}
/// 判断某个文件是否存在
func isFileExists(fileName: String) -> Bool {
    let filePath:String = NSHomeDirectory() + "/Documents/" + fileName
    let fileManager:FileManager = FileManager.default
    let exist = fileManager.fileExists(atPath: filePath)
    return exist
}
/// 写入某个文件
func saveFileMsg(msg: String, fileName: String) -> Bool {
    let filePath:String = NSHomeDirectory() + "/Documents/" + fileName
    do {
        try msg.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        return true
    } catch let error {
        print("写入失败 = \(error)")
        return false
    }
}
/// 删除某个文件
func removeFile(fileName: String) -> Bool {
    let filePath:String = NSHomeDirectory() + "/Documents/" + fileName
    let fileManager:FileManager = FileManager.default
    do {
        try fileManager.removeItem(atPath: filePath)
        return true
    } catch let err {
        print("删除文件失败 = \(err)")
        return false
    }
}
/// 获取某个文件内容
func getFileMessage(fileName: String) -> String {
    let filePath:String = NSHomeDirectory() + "/Documents/" + fileName
    let readHandler = FileHandle(forReadingAtPath: filePath)
    let data = readHandler?.readDataToEndOfFile()
    if data == nil {
        return ""
    } else {
        return String(data: data!, encoding: .utf8) ?? ""
    }
}
class XDTools: NSObject {

}

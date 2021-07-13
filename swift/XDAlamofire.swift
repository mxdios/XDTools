//
//  XDAlamofire.swift
//  inspos
//
//  Created by miaoxiaodong on 2020/7/3.
//  Copyright © 2020 inspiry. All rights reserved.
//

import UIKit
import Alamofire

/// 网络请求成功的回调
typealias success = (_ responseData: AnyObject) -> Void
/// 网络请求失败的回调
typealias fail = (_ error: AnyObject) -> Void

class XDAlamofire: NSObject {
    //MARK: var & let
        static let share  = XDAlamofire()
        private lazy var sessionManager: Session = {
            return Session.default
        }()
    
///    基础网络请求
    func base(url: String, method: HTTPMethod, params: [String: Any]?, success: @escaping success, fail: @escaping fail) {
        var headers = HTTPHeaders(["Authorization" : "Bearer \(getToken() ?? "")"])
        if url == APP_URLrefreshtoken() { //刷新token
            headers = HTTPHeaders(["Authorization" : "Bearer \(getRefreshToken() ?? "")"])
        }
        self.sessionManager.request(url, method: method, parameters: params, headers: headers).responseJSON { (response) in
            switch response.result {
                case .success(let json):
                    if let dict = json as? [String: Any] {
                        if dict["code"] as? Int == 101009 || dict["code"] as? Int == 101004 {
                            NotificationCenter.default.post(name: XDNotName.tokenLoseLogout, object: nil)
                        } else {
                            success(json as AnyObject)
                        }
                    }
                case .failure(let error):
                    HUD.hide()
                    HUD.flash(.labeledError(title: "netlinkerror".localized, subtitle: error.errorDescription), delay: 1)
                    fail(error as AnyObject)
            }
        }
    }
///    GET 拼接链接
    public func getLink(url: String, params: String?, success: @escaping success, fail: @escaping fail) {
        let requestUrl:String = params == nil ? url : url + params!
        XDLog("GET Link 请求：\(requestUrl)")
        base(url: requestUrl, method: .get, params: nil, success: success, fail: fail)
    }
    
///    GET
    public func get(url: String, params: [String : Any]?, success: @escaping success, fail: @escaping fail) {
        var tempParams = params
        if tempParams == nil {
            tempParams = Dictionary()
        }
        XDLog("GET 请求：\(url), 参数 = \(tempParams!)")
        base(url: url, method: .get, params: tempParams, success: success, fail: fail)
    }
    
///    POST
    public func post(url: String, params: [String : Any]?, success: @escaping success, fail: @escaping fail) {
        var tempParams = params
        if tempParams == nil {
            tempParams = [String: Any]()
        }
        XDLog("POST 请求：\(url), 参数 = \(tempParams!)")
        base(url: url, method: .post, params: tempParams, success: success, fail: fail)
    }
///    POST Body请求
    public func postBody(url: String, params: [String: Any]?, success: @escaping success, fail: @escaping fail) {
        var tempParams = params
        if tempParams == nil {
            tempParams = [String: Any]()
        }
        XDLog("POST Body 请求：\(url), 参数 = \(tempParams!)")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(getToken() ?? "")", forHTTPHeaderField: "Authorization")
        let data = try? JSONSerialization.data(withJSONObject: tempParams!, options: [])
        request.httpBody = data
        self.sessionManager.request(request).responseJSON { (response) in
            switch response.result {
                case .success(let json):
                    if let dict = json as? [String: Any] {
                        if dict["code"] as? Int == 101009 || dict["code"] as? Int == 101004 {
                            NotificationCenter.default.post(name: XDNotName.tokenLoseLogout, object: nil)
                        } else {
                            success(json as AnyObject)
                        }
                    }
                case .failure(let error):
                    HUD.hide()
                    HUD.flash(.labeledError(title: "netlinkerror".localized, subtitle: error.errorDescription), delay: 1)
                    fail(error as AnyObject)
            }
        }
    }
/// POST Body 响应字符串请求
    public func postBodyRspStr(url: String, params: [String: Any]?, success: @escaping success, fail: @escaping fail) {
        var tempParams = params
        if tempParams == nil {
            tempParams = [String: Any]()
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(getToken() ?? "")", forHTTPHeaderField: "Authorization") // 只用数据埋点，不传token
        let data = try? JSONSerialization.data(withJSONObject: tempParams!, options: [])
        request.httpBody = data
        self.sessionManager.request(request).responseString { response in
            switch response.result {
            case .success(let str):
                success(str as AnyObject)
            case .failure(let err):
                fail(err as AnyObject)
            }
        }
    }
///    POST 文件上传
    public func postFile(url: String, data: MultipartFormData, success: @escaping success, fail: @escaping fail) -> UploadRequest {
        XDLog("POST 文件上传 请求：\(url)")
        let headers = HTTPHeaders(["Authorization" : "Bearer \(getToken() ?? "")"])
        let upLoadRequest:UploadRequest = self.sessionManager.upload(multipartFormData: data, to: url, headers: headers).responseJSON { (response) in
            XDLog(response)
            switch response.result {
            case .success(let json):
                if let dict = json as? [String: Any] {
                    if dict["code"] as? Int == 101009 || dict["code"] as? Int == 101004 {
                        NotificationCenter.default.post(name: XDNotName.tokenLoseLogout, object: nil)
                    } else {
                        success(json as AnyObject)
                    }
                }
            case .failure(let error):
                HUD.hide()
                HUD.flash(.labeledError(title: "netlinkerror".localized, subtitle: error.errorDescription), delay: 1)
                fail(error as AnyObject)
            }
        }
        return upLoadRequest
    }
///  POST Body Routeman设备列表嵌套用户资料
    public func postBodyOfUser(url: String, params: [String: Any]?, success: @escaping success, fail: @escaping fail) {
        
        let rouLevel = getRoutemanLevel()
        if rouLevel == 2 || rouLevel == 3 || rouLevel == 4 {
            let tokenDict = getTokenDict()!
            let dictInn = ["id": tokenDict["userId"]]
            get(url: APP_URLGetBDUser(), params: dictInn as [String : Any]) { (resData) in
                let dict = resData["data"] as? Dictionary<String, Any>
                if (resData["success"] as? Bool == true && dict != nil) {
                    setUserInfo(info: dict!)
                    XDLog("bd用户资料 = \(dict!)")
                    var paramsInn = params!
                    paramsInn["customerIdList"] = getUserInfo()!["customerIdList"]
                    self.postBody(url: url, params: paramsInn, success: success, fail: fail)
                } else {
                    HUD.flash(.labeledError(title: "netlinkerror".localized, subtitle: nil), delay: 1)
                    fail("用户信息加载失败" as AnyObject)
                }
            } fail: { (error) in
                HUD.hide()
                HUD.flash(.labeledError(title: "netlinkerror".localized, subtitle: nil), delay: 1)
                fail(error as AnyObject)
            }
        } else {
            postBody(url: url, params: params, success: success, fail: fail)
        }
    }
}

//
//  WebViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/5/4.
//  Copyright © 2019 monash. All rights reserved.
//
// https://benoitpasquier.com/ios-and-javascript/
// https://developer.apple.com/documentation/webkit/wkwebview
// https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview
// https://developer.apple.com/documentation/foundation/nsdictionary

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var user_inf = [UnitData]()
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let myURL = URL(string:"https://monashuni.okta.com/app/monashuniversity_allocateplus_1/exk1lqfohscjojl1p2p7/sso/saml")
        let myURL = URL(string:"https://my-timetable.monash.edu/odd/student?ss=503350ab070d40fea4fe311f690e7e39")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    @IBAction func syncButton(_ sender: Any) {
        webView.evaluateJavaScript("JSON.stringify(data.student)"){(data,error) in
            if let data = data as? String {
                do {
                    let decoder = JSONDecoder()
                    print(data)
                    let volumeData = try decoder.decode(VolumeData.self, from: data.data(using: .utf8)!)
                    self.user_inf = [volumeData.units!]
                    print(self.user_inf)
                } catch let error {
                    //self.webView.reload()
                    //self.webView.goBack()
                    print("JSONDecoderError:\(error)")
                }
            }
            else {
                print("evaluateJavaScriptError")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

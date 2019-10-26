//
//  MovieVideoViewController.swift
//  FlixApp
//
//  Created by Rotimi Awani on 10/25/19.
//  Copyright © 2019 Rotimi Awani. All rights reserved.
//

import UIKit
import WebKit

class MovieVideoViewController: UIViewController, WKUIDelegate{
    
    var webView: WKWebView!
    var movie: [String:Any]!
    var moviesVideo = [[String:Any]]()
    var myVideo: [String:Any]  = [:]
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = movie["id"] as! Int
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + "\(id)" + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

              //Store result from dataDictionary in movies( List of dictionaries )
              self.moviesVideo = dataDictionary["results"] as! [[String:Any]]
              self.myVideo = self.moviesVideo[0]
              let key = self.myVideo["key"]!
              
              let videoUrl = URL(string:"https://www.youtube.com/watch?v=\(key)")
              let myRequest = URLRequest(url: videoUrl!)
              self.webView.load(myRequest)

           }
        }
        task.resume()
    }
    
    @IBAction func closeVideo(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

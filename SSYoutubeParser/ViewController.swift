//
//  ViewController.swift
//  SSYoutubeParser
//
//  Created by leznupar999 on 2015/06/03.
//  Copyright (c) 2015 leznupar999. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var avPlayerView: AVPlayerView!
    
    let youtubeID = "NetDBUYr3OE"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SSYoutubeParser.h264videosWithYoutubeID(self.youtubeID, completionHandler: { (videoDictionary) -> Void in
            let videoSmallURL = videoDictionary["small"]
            let videoMediumURL = videoDictionary["medium"]
            let videoHD720URL = videoDictionary["hd720"]
            
            if let urlStr = videoHD720URL {
                if let playerItem = AVPlayerItem(URL: NSURL(string: urlStr)) {
                    self.avPlayerView.player = AVPlayer(playerItem: playerItem)
                    playerItem.addObserver(self, forKeyPath: "status", options:.New | .Old | .Initial, context: nil)
                }
            }
        })
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            let changeOld = change["old"] as? NSNumber
            let changeNew = change["new"] as? NSNumber
            let status = object.status as AVPlayerItemStatus
            
            if changeOld == 0 && changeNew == 1 && status == AVPlayerItemStatus.ReadyToPlay {
                self.avPlayerView.player.play()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


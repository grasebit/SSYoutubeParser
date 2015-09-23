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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVideo()
    }
    
    
    func setupVideo() {
        SSYoutubeParser.h264videosWithYoutubeID("b2fjU9cmjXg") { (videoDictionary) -> Void in
            //let videoSmallURL = videoDictionary["small"]
            let videoMediumURL = videoDictionary["medium"]
            //let videoHD720URL = videoDictionary["hd720"]
            
            if let urlStr = videoMediumURL {
                if let playerItem:AVPlayerItem = AVPlayerItem(URL: NSURL(string: urlStr)!) {
                    self.avPlayerView.player = AVPlayer(playerItem: playerItem)
                    playerItem.addObserver(self, forKeyPath: "status", options: [.New,.Old,.Initial], context: nil)
                }
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            let change2 = change!
            let changeOld = change2["old"] as? NSNumber
            let changeNew = change2["new"] as? NSNumber
            let status = object!.status as AVPlayerItemStatus
            
            if changeOld == 0 && changeNew == 1 && status == AVPlayerItemStatus.ReadyToPlay {
                self.avPlayerView.player.play()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

}


//
//  SSYoutubeParser.swift
//  SSYoutubeParser
//
//  Created by leznupar999 on 2015/06/03.
//  Copyright (c) 2015 leznupar999. All rights reserved.
//

import Foundation

class SSYoutubeParser: NSObject {
   
    static let kYoutubeURL:String = "https://www.youtube.com/watch?v="
    static let kYoutubeVideoInfoURL:NSString = "https://www.youtube.com/get_video_info?video_id=%@&asv=3&el=detailpage&ps=default&hl=en_US"
    static let kURLEncodedFmtStreamMap:String = "(url_encoded_fmt_stream_map=)(.*?)(&)"
    static let kAdaptiveFmts:String = "(adaptive_fmts=)(.*?)(&)"

    
    class func h264videosWithYoutubeID(youtubeID :String, completionHandler handler:(videoDictionary :[String:String]) -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let videoDictionary = self.getStreams(youtubeID)
            
            dispatch_async(dispatch_get_main_queue() , { () -> Void in
                handler(videoDictionary: videoDictionary)
            })
        })
    }
    
    private class func getStreams(youtubeID :String) -> [String:String] {
        var videoDictionary = [String:String]()
        
        let urlStr = NSString(format: kYoutubeVideoInfoURL, youtubeID)
        let url = NSURL(string: urlStr as String)
        let req = NSMutableURLRequest(URL: url!)
        req.addValue("en", forHTTPHeaderField: "Accept-Language")
        
        var uRLResponse : NSURLResponse?
        let data:NSData = try! NSURLConnection.sendSynchronousRequest(req, returningResponse: &uRLResponse)
        if data.length == 0 {
            return videoDictionary
        }
        let html = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        var regex: NSRegularExpression?
        regex = try! NSRegularExpression(pattern: kURLEncodedFmtStreamMap, options: NSRegularExpressionOptions())
        
        if regex == nil {
            return videoDictionary
        }
        
        if let result = regex?.firstMatchInString(html as String!, options: NSMatchingOptions(), range: NSMakeRange(0, html!.length)) {
            
            if let streamMap :NSString = html?.substringWithRange(result.rangeAtIndex(2)) {
                
                let decodeMap :NSString = streamMap.stringByRemovingPercentEncoding!
                print(decodeMap)
                
                let fmtStreamMapArray = decodeMap.componentsSeparatedByString(",") 
                
                for stream in fmtStreamMapArray {
                    let videoComponents = self.dictionaryFromQueryStringComponents(stream as NSString)
                    let typeArray = videoComponents["type"]
                    var typeStr = typeArray?.objectAtIndex(0) as! NSString
                    typeStr = self.stringByDecodingURLFormat(typeStr)
                    
                    var signature :NSString?
                    
                    if let itag = videoComponents["itag"] {
                        signature = itag.objectAtIndex(0) as? NSString
                    }
                    
                    if signature != nil && typeStr.rangeOfString("mp4").length > 0 {
                        let urlArr = videoComponents["url"]
                        var streamUrl = urlArr?.objectAtIndex(0) as! NSString
                        streamUrl = self.stringByDecodingURLFormat(streamUrl)
                        streamUrl = NSString(format: "%@&signature=%@", streamUrl, signature!)
                        
                        let qualityArr = videoComponents["quality"]
                        var quality = qualityArr?.objectAtIndex(0) as! NSString
                        quality = self.stringByDecodingURLFormat(quality)
                        
                        if let stereo3d = videoComponents["stereo3d"],let bl = stereo3d.objectAtIndex(0) as? NSString {
                            if bl.boolValue {
                                quality = quality.stringByAppendingString("-stereo3d")
                            }
                        }
                        
                        if videoDictionary[quality as String] == nil {
                            videoDictionary[quality as String] = streamUrl as String
                        }
                    }
                }
            }
        }
        
        return videoDictionary
    }

    private class func stringByDecodingURLFormat(value :NSString) -> NSString {
        var result :NSString = value.stringByReplacingOccurrencesOfString("+", withString: " ")
        result = result.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return result
    }
    
    private class func dictionaryFromQueryStringComponents(stream :NSString) -> [String:NSMutableArray] {
        var parameters = [String:NSMutableArray]()
        
        for keyValue in stream.componentsSeparatedByString("&") {
            let keyValueStr = keyValue as NSString
            let keyValueArray:[AnyObject] = keyValueStr.componentsSeparatedByString("=")
            if keyValueArray.count < 2 {
                continue
            }
            
            let key = self.stringByDecodingURLFormat(keyValueArray[0] as! NSString)
            let value = self.stringByDecodingURLFormat(keyValueArray[1] as! NSString)
            
            var results = parameters[key as String]
            
            if results == nil {
                results = NSMutableArray(capacity: 1)
                parameters[key as String] = results
            }
            
            results?.addObject(value)
            
        }
        return parameters
    }
}

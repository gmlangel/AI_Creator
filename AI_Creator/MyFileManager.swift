//
//  FileManager.swift
//  AI_Creator
//
//  Created by guominglong on 2019/7/26.
//  Copyright © 2019 ai. All rights reserved.
//

import Foundation
import Cocoa
struct FileManagerStruct {
    static var RootDriectory:String = "";
}

class MyFileManager: NSObject {
    static var RootDirectory:String{
        get{
            if "" == FileManagerStruct.RootDriectory{
                let pathArr = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                if pathArr.count > 0{
                    FileManagerStruct.RootDriectory = pathArr[0] + "/";
                }
            }
            return FileManagerStruct.RootDriectory;
        }
    }
    
    static var ProjectDirectory:String = "";
}

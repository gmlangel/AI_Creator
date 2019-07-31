//
//  VC_NewProject.swift
//  AI_Creator
//
//  Created by guominglong on 2019/7/26.
//  Copyright © 2019 ai. All rights reserved.
//

import Foundation
import Cocoa
let regular = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9\\_]{0,30}$");

class VC_NewProject: NSViewController {
    @IBOutlet weak var tb_newProject: NSTextField?;
    
    @IBAction func onSubmit(_ sender: NSButton) {
        if let value = tb_newProject?.stringValue ,regular.evaluate(with: value) == true{
            NotificationCenter.default.post(name: Notify_NewProject, object: value);
            self.dismiss(self);
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(self);
    }
    
    
}

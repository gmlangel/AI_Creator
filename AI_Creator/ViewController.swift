//
//  ViewController.swift
//  AI_Creator
//
//  Created by guominglong on 2019/7/25.
//  Copyright © 2019 ai. All rights reserved.
//

import Cocoa
import SnapKit
let Notify_NewProject = Notification.Name.init("Notify_NewProject");
class ViewController: NSViewController {
    var mainTimeline:MainTimeLineView!;
    var videoPlayer:VideoPlayerContainer!;
    var mediaResourceView:MediaResourceView!;
    var resourceList:ResourceListView!;
    var customToolBar:MyToolBar!;
    var alert:NSAlert = NSAlert()
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerV = self.view;
        //初始化视图
        mainTimeline = MainTimeLineView(frame:NSRect(x: 0, y: 0, width: 100, height: 100));
        mainTimeline.wantsLayer = true;
        mainTimeline.layer?.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor;
        containerV.addSubview(mainTimeline);
        mainTimeline.snp.makeConstraints { (make) in
            make.height.equalTo(60);
            make.top.equalTo(containerV).offset(68);
            make.left.equalTo(5);
            make.right.equalTo(containerV).offset(-210);
        }
        
        
        mediaResourceView = MediaResourceView(frame:NSRect(x: 0, y: 0, width: 100, height: 100));
        mediaResourceView.wantsLayer = true;
        mediaResourceView.layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor;
        containerV.addSubview(mediaResourceView);
        mediaResourceView.snp.makeConstraints { (make) in
            make.top.equalTo(mainTimeline.snp.bottom).offset(5);
            make.height.equalTo(40);
            make.left.equalTo(5);
            make.right.equalTo(containerV).offset(-210);
        }
        
        videoPlayer = VideoPlayerContainer(frame:NSRect(x: 0, y: 0, width: 100, height: 100));
        videoPlayer.wantsLayer = true;
        videoPlayer.layer?.backgroundColor = NSColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor;
        containerV.addSubview(videoPlayer);
        videoPlayer.snp.makeConstraints { (make) in
            make.top.equalTo(mediaResourceView.snp.bottom).offset(5);
            make.left.equalTo(5);
            make.right.equalTo(containerV).offset(-210);
            make.bottom.equalTo(containerV).offset(-5);
        }
        
        
        resourceList = ResourceListView(frame:NSRect(x: 0, y: 0, width: 100, height: 100));
        resourceList.wantsLayer = true;
        resourceList.layer?.backgroundColor = NSColor(red: 0.3, green: 0.1, blue: 0.8, alpha: 1).cgColor;
        containerV.addSubview(resourceList);
        resourceList.snp.makeConstraints { (make) in
            make.top.equalTo(containerV).offset(68);
            make.width.equalTo(200);
            make.right.equalTo(containerV).offset(-5);
            make.bottom.equalTo(containerV).offset(-5);
        }
        self.addNotifications();
    }
    
    func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(onNewProject), name: Notify_NewProject, object: nil)
        
    }
    
    override func viewWillAppear() {
        let containerV = self.view;
        //自定义toolbar
        customToolBar = MyToolBar(identifier: "ai_ToolBar");
        customToolBar.vc = self;
        containerV.window?.toolbar = customToolBar;
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //MARK:----------业务处理--------------
    @objc func onNewProject(_ notify:Notification){
        var isComplete = false;
        var userinfo = ["code":0,"msg":""] as [String : Any];
        if let name = notify.object as? String{
            let path = "\(MyFileManager.RootDirectory)\(name)/";///
            var ob:ObjCBool = false;
            if FileManager.default.fileExists(atPath: path, isDirectory: &ob) == false{
                do{
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil);
                    let filepath = "\(path)pro.json";
                    try "".write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
                    isComplete = true;
                    MyFileManager.ProjectDirectory = path;//存储项目路径
                }catch{
                    NSLog("\(error.localizedDescription)")
                    userinfo["code"] = 1;
                    userinfo["msg"] = "项目创建失败，原因:\(error.localizedDescription)"
                }
            }else{
                userinfo["code"] = 2;
                userinfo["msg"] = "项目创建失败，原因:项目已存在"
            }
        }else{
            userinfo["code"] = 3;
            userinfo["msg"] = "项目名称为空"
        }
        if isComplete == false{
            //弹提示
            alert.messageText = userinfo["msg"] as! String;
        }else{
            alert.messageText = "创建成功"
        }
        alert.alertStyle = NSAlert.Style.warning
        alert.runModal();
    }

}

//新建项目
let newProjectItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier.init("toolbar_newProjectItem");

//导入项目
let importProjectItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier.init("toolbar_importProjectItem");

//预览
let preViewItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier.init("toolbar_preBuildItem");

//发布
let publishItem:NSToolbarItem.Identifier = NSToolbarItem.Identifier.init("toolbar_publishItem");

class MyToolBar: NSToolbar,NSToolbarDelegate,NSToolbarItemValidation {
    
    weak var vc:NSViewController?
//    let customItemIDArr = [
//        newProjectItem,
//        importProjectItem,
//        preViewItem,
//        publishItem,
//    ]
//
    let systemItemIDArr = [
        NSToolbarItem.Identifier.showColors,
        NSToolbarItem.Identifier.space,
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier.showFonts,
        NSToolbarItem.Identifier.print
    ]
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier);
        self.allowsUserCustomization = false
        self.showsBaselineSeparator = false
        self.sizeMode = .small
        self.delegate = self
        //        toolbar?.autosavesConfiguration = true
        //        toolbar?.allowsExtensionItems = true
        self.displayMode = .iconAndLabel
    }
    
    /**
     刷新toolbar
     */
    open func referenceToolBar(){
        self.validateVisibleItems()
    }
    
    @objc func onNewProjectClick(){
        if let v = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(stringLiteral: "newproject")) as? NSViewController{
            vc?.presentAsModalWindow(v);
        }
    }
    
    @objc func onImportProjectClick(){
        NSLog("导入项目")
    }
    
    @objc func onPreViewClick(){
        NSLog("预览")
    }
    
    @objc func onPublishClick(){
        NSLog("发布")
    }
    
    //MARK:----------NSToolbarItemValidation实现-----------
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        return true
    }
    //MARK:----------NSToolbarDelegate实现-----------
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        //注册  支持类型
        return [
                newProjectItem,
                importProjectItem,
                preViewItem,
                publishItem,
                NSToolbarItem.Identifier.space,
                NSToolbarItem.Identifier.flexibleSpace
        ];
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?;
        if itemIdentifier == newProjectItem{
            let img = NSImage(named: NSImage.Name(NSString(string:"PT_TEA_HAT00_1-1")))
            toolbarItem = customToolbarItem(itemForItemIdentifier: itemIdentifier, label: "新建项目", paletteLabel: "", toolTip: "新建项目", target: self, itemContent: img!, action: #selector(onNewProjectClick), menu: nil);
        }else if itemIdentifier == importProjectItem{
            let img = NSImage(named: NSImage.Name(NSString(string:"PT_TEA_CUP00_1-5")))
            toolbarItem = customToolbarItem(itemForItemIdentifier: itemIdentifier, label: "导入项目", paletteLabel: "", toolTip: "导入项目", target: self, itemContent: img!, action: #selector(onImportProjectClick), menu: nil);
        }else if itemIdentifier == preViewItem{
            let img = NSImage(named: NSImage.Name(NSString(string:"PT_TEA00_1-1")))
            toolbarItem = customToolbarItem(itemForItemIdentifier: itemIdentifier, label: "预览", paletteLabel: "", toolTip: "预览", target: self, itemContent: img!, action: #selector(onPreViewClick), menu: nil);
        }else if itemIdentifier == publishItem{
            let img = NSImage(named: NSImage.Name(NSString(string:"PT_WOOD00_1-1")))
            toolbarItem = customToolbarItem(itemForItemIdentifier: itemIdentifier, label: "发布", paletteLabel: "", toolTip: "发布", target: self, itemContent: img!, action: #selector(onPublishClick), menu: nil);
        }else if systemItemIDArr.contains(itemIdentifier){
            toolbarItem = NSToolbarItem.init(itemIdentifier: itemIdentifier);
        }
        return toolbarItem
    }
    
    // MARK: 设置自定义按钮视图
    func customToolbarItem(itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, label: String, paletteLabel: String, toolTip: String, target: AnyObject, itemContent: AnyObject, action: Selector?, menu: NSMenu?) -> NSToolbarItem? {
        
        let toolbarItem = NSToolbarItem(itemIdentifier:itemIdentifier)
        
        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip
        toolbarItem.target = target
        toolbarItem.action = action
        
        // Set the right attribute, depending on if we were given an image or a view.
        if (itemContent is NSImage) {
            let image: NSImage = itemContent as! NSImage
            toolbarItem.image = image
        }
        else if (itemContent is NSView) {
            let view: NSView = itemContent as! NSView
            toolbarItem.view = view
        }
        else {
            assertionFailure("Invalid itemContent: object")
        }
        
        // We actually need an NSMenuItem here, so we construct one.
        //        let menuItem: NSMenuItem = NSMenuItem()
        //        menuItem.submenu = menu
        //        menuItem.title = label
        //        toolbarItem.menuFormRepresentation = menuItem
        //
        return toolbarItem
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        //设置 默认显示的按钮
        return [newProjectItem,importProjectItem,preViewItem,publishItem,NSToolbarItem.Identifier.space];
    }
    
}

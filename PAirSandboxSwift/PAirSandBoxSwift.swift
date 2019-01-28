//
//  PAirSandBoxSwift.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/28.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

// Inpired by https://github.com/music4kid/AirSandbox

private struct PAirSandBoxConstant {
    static let asThemeColor = UIColor.init(white: 0.2, alpha: 1.0)
    static let asWindowPadding: CGFloat = 20
    static var cellWidth: CGFloat {
        return UIScreen.main.bounds.width - (2 * self.asWindowPadding)
    }
}

private enum ASFileItemType {
    case up,directory,file
}

// ************** ASFileItem ***************
private class ASFileItem: NSObject {
    var name: String
    var path: String
    var type: ASFileItemType
    
    init(name: String, path: String, type: ASFileItemType) {
        self.name = name
        self.path = path
        self.type = type
        
        super.init()
    }
}

// ************** PAirSandboxCell ***************
private class PAirSandboxCell: UITableViewCell {
    //reuse idenfifier
    static let classIdenfifier = String(describing: self)
    
    lazy var lbName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .left
        label.frame = CGRect(x: 10,
                             y: 30,
                             width: PAirSandBoxConstant.cellWidth,
                             height: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = PAirSandBoxConstant.asThemeColor
        line.frame = CGRect(x: 10,
                            y: 47,
                            width: PAirSandBoxConstant.cellWidth - 20,
                            height: 1)
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(lbName)
        addSubview(line)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(with item: ASFileItem) {
        lbName.text = item.name
    }
}


// ************** ASViewController ***************
private class ASViewController: UIViewController {
    
    var items: [ASFileItem] = []
    var rootPath = NSHomeDirectory()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = PAirSandBoxConstant.asThemeColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Close", for: .normal)
        button.addTarget(self,
                         action: #selector(closeButtonClick),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(closeButton)
        view.addSubview(tableView)
        loadFiles()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewWidth = PAirSandBoxConstant.cellWidth
        let closeButtonHeight: CGFloat = 28.0
        let closeButtonWidth: CGFloat  = 60
        closeButton.frame = CGRect(x: viewWidth - closeButtonWidth - 4,
                                   y: 4,
                                   width: closeButtonWidth,
                                   height: closeButtonHeight)
        var frame = view.frame
        frame.origin.y += (closeButtonHeight + 4)
        frame.size.height -= (closeButtonHeight + 4)
        tableView.frame = frame
        
    }
    
    private func loadFiles( path: String? = nil) {
        var files: [ASFileItem] = []
        
        var targetPath: String? = path
        if let targetPath = targetPath, targetPath != rootPath {
            let file = ASFileItem(name: "🔙..", path: targetPath, type: .up)
            files.append(file)
        }else {
            targetPath = rootPath
        }
        let fm = FileManager.default
        do {
            let paths = try fm.contentsOfDirectory(atPath: targetPath!) as [NSString]
            let targetPath = targetPath! as NSString
            var isDir: ObjCBool = false
            for path in paths {
                if path.lastPathComponent.hasPrefix(".") { continue }
                let fullPath = targetPath.appendingPathComponent(path as String)
                fm.fileExists(atPath: fullPath, isDirectory: &isDir)
                let file = ASFileItem(name: "", path: fullPath, type: .file)
                if isDir.boolValue {
                    file.name = "📁" + " " + (path as String)
                    file.type = .directory
                }else {
                    file.name = "📄" + " " + (path as String)
                    file.type = .file
                }
                files.append(file)
            }
            items = files
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Events Response
    @objc private  func closeButtonClick() {
        view.window?.isHidden = true
    }
    
    private func share(file path: String) {
        
        let url = URL(fileURLWithPath: path)
        
        let shareController = UIActivityViewController(activityItems: [url],
                                                       applicationActivities: nil)
        
        shareController.excludedActivityTypes = [
            .postToWeibo,
            .message,
            .mail,
            .print,
            .saveToCameraRoll,
            .copyToPasteboard,
            .postToTencentWeibo,
            .postToFlickr,
            .postToVimeo,
            .assignToContact,
            .addToReadingList
        ]
        
        if UIDevice.current.model.hasPrefix("iPad") {
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.size.width * 0.5,
                y: UIScreen.main.bounds.size.height,
                width: 10,
                height: 10)
        }
        
        present(shareController, animated: true, completion: nil)
    }
    
}

extension ASViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > (items.count - 1) { return }
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        switch item.type {
        case .up:
            loadFiles(path: (item.path as NSString).deletingLastPathComponent)
        case .file:
            share(file:  item.path)
        case .directory:
            loadFiles(path: item.path)
        }
    }
}

extension ASViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > (items.count - 1) {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        let cell: PAirSandboxCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: PAirSandboxCell.classIdenfifier) as? PAirSandboxCell  {
            cell = reuseCell
        }else {
            cell = PAirSandboxCell(style: .default, reuseIdentifier: PAirSandboxCell.classIdenfifier)
        }
        cell.render(with: item)
        return cell
    }
}

// ************** PAirSandboxCell ***************
public class PAirSandBoxSwift: NSObject {
    
    static let shared = PAirSandBoxSwift()
    
    lazy var window: UIWindow = {
        let window = UIWindow()
        var keyFrame = UIScreen.main.bounds
        keyFrame.origin.y += 64
        keyFrame.size.height -= 64
        window.frame = keyFrame.insetBy(
            dx: PAirSandBoxConstant.asWindowPadding,
            dy: PAirSandBoxConstant.asWindowPadding)
        window.backgroundColor = .white
        window.layer.borderColor = PAirSandBoxConstant.asThemeColor.cgColor
        window.layer.borderWidth = 2.0
        
        window.windowLevel = .statusBar
        window.rootViewController = viewController
        
        return window
    }()
    
    lazy private var viewController = ASViewController()
    
    
    public func enableSwipe() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDetected(gs:)))
        swipeGesture.numberOfTouchesRequired = 1
        UIApplication.shared.keyWindow?.addGestureRecognizer(swipeGesture)
    }
    
    public func showSandboxBrowser () {
        window.isHidden = false
    }
    
    @objc private func onSwipeDetected(gs: UISwipeGestureRecognizer) {
        showSandboxBrowser()
    }
    
}

////
////  phase3.swift
////  SnapshotSharingSessionTests
////
////  Created by Ambar Septian on 19/02/20.
////  Copyright © 2020 Ambar Septian. All rights reserved.
////
//
//import XCTest
//@testable import SnapshotSharingSession
//
//class CustomTableViewControllerTests: SnapshotTestCase {
//
//    func testCustomTableViewControllerView() {
//        let viewController = CustomTableViewController()
//        assertSnapshot(matching: viewController.view)
//    }
//}
//
//
//protocol Snapshottable {
//    associatedtype Snapshot: Diffable
//    var snapshot: Snapshot { get }
//    static var pathExtension: String { get }
//}
//
//protocol Diffable {
//    static func diff(old: Self, new: Self) -> (String, [XCTAttachment])?
//    static func from(data: Data) -> Self
//    var to: Data { get }
//}
//
//extension UIImage: Diffable {
//    static func from(data: Data) -> Self {
//        return self.init(data: data, scale: UIScreen.main.scale)!
//    }
//    
//    static func diff(old: UIImage, new: UIImage) -> (String, [XCTAttachment])? {
//        guard let difference = Diff.images(old, new) else { return nil }
//        return (
//            "Expected old@\(old.size) to match new@\(new.size)",
//            [old, new, difference].map(XCTAttachment.init)
//        )
//    }
//    
//    var to: Data {
//        return self.pngData()!
//    }
//}
//
//extension UIView: Snapshottable {
//    //    var snapshot: UIImage {
//    //        return layer.snapshot
//    //    }
//    
//    var snapshot: String {
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        
//        return (self.perform(Selector(("recursiveDescription")))?.takeUnretainedValue() as! String)
//            .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
//    }
//}
//
//extension UIViewController: Snapshottable {
//    //    var snapshot: UIImage {
//    //        return view.snapshot
//    //    }
//    
//    var snapshot: String {
//        return view.snapshot
//    }
//}
//
//extension CALayer: Snapshottable {
//    var snapshot: UIImage {
//        return UIGraphicsImageRenderer(size: bounds.size)
//            .image { ctx in render(in: ctx.cgContext) }
//    }
//}
//
//extension UIImage: Snapshottable {
//    var snapshot: UIImage {
//        return self
//    }
//}
//
//extension Snapshottable where Snapshot == UIImage {
//    static var pathExtension: String { "png"}
//}
//
//
//extension String: Diffable {
//    static func diff(old: String, new: String) -> (String, [XCTAttachment])? {
//        guard let difference = Diff.lines(old, new) else { return nil }
//        return (
//            "Diff: …\n\(difference)",
//            [XCTAttachment(string: difference)]
//        )
//    }
//    
//    static func from(data: Data) -> String {
//        return String.init(decoding: data, as: UTF8.self)
//    }
//    
//    var to: Data {
//        return Data(self.utf8)
//    }
//}
//
//extension String: Snapshottable {
//    var snapshot: String {
//        return self
//    }
//    
//    typealias Snapshot = String
//}
//
//extension Snapshottable where Snapshot == String {
//    static var pathExtension: String { "txt" }
//}

//
//  phase4.swift
//  SnapshotSharingSessionTests
//
//  Created by Ambar Septian on 20/02/20.
//  Copyright © 2020 Ambar Septian. All rights reserved.
//

import XCTest
@testable import SnapshotSharingSession

class CustomTableViewControllerTests4: XCTestCase {
    
    func testCustomTableViewControllerView() {
        let viewController = CustomTableViewController()
        assertSnapshot(matching: viewController.view, as: .image)
        assertSnapshot(matching: viewController.view, as: .recursiveDescription)
    }
    
    
    func assertSnapshot<Value, Format>(
        matching value: Value,
        as witness: Snapshotting<Value,Format>,
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line) {

        let snapshot = witness.snapshot(value)
        let referenceUrl = snapshotUrl(file: file, function: function)
            .appendingPathExtension(witness.pathExtension)

        if !record, let referenceData = try? Data(contentsOf: referenceUrl) {
            let reference = witness.diffing.from(referenceData)

            guard let (failure, attachments) = witness.diffing.diff(reference, snapshot) else {
                return
            }
            XCTFail(failure, file: file, line: line)
            XCTContext.runActivity(named: "Attached failure diff") { activity in
                attachments
                    .forEach(activity.add)
            }
        } else {
            try! witness.diffing.data(snapshot).write(to: referenceUrl)
            XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
        }
    }
    
}

/* Protocol Style
protocol Diffable {
    static func diff(old: Self, new: Self) -> (String, [XCTAttachment])?
    static func from(data: Data) -> Self
    var to: Data { get }
}
*/

/* Witness Style */
struct Diffing<Value> {
    let diff: (Value, Value) -> (String, [XCTAttachment])?
    let from: (Data) -> Value
    let data: (Value) -> Data
}

/* Protocol Style
protocol Snapshottable {
    associatedtype Snapshot: Diffable
    var snapshot: Snapshot { get }
    static var pathExtension: String { get }
}
*/

struct Snapshotting<Value, Format> {
    let diffing: Diffing<Format>
    let pathExtension: String
    let snapshot: (Value) -> Format
    
    // add pullback here later
    func pullback<NewValue>(_ f:@escaping(NewValue) -> Value) -> Snapshotting<NewValue, Format> {
        
        return Snapshotting<NewValue, Format>(
            diffing: self.diffing,
            pathExtension: self.pathExtension,
            snapshot: { a0 in self.snapshot(f(a0)) }
        )
    }
}



extension Diffing where Value == UIImage {
    static let image = Diffing(diff: { (old, new) -> (String, [XCTAttachment])? in
        guard let difference = Diff.images(old, new) else { return nil}
        return (
            "Expected old@\(old.size) to match new@\(new.size)",
            [old, new, difference].map(XCTAttachment.init)
            )
        },
        from: { data in UIImage(data: data, scale: UIScreen.main.scale)!},
        data: { image in image.pngData()! })
}




extension Snapshotting where Value == UIImage, Format == UIImage {
    static let image = Snapshotting(diffing: .image,
                                    pathExtension: "png",
                                    snapshot: { $0 })
}

//
//extension Snapshotting where Value == CALayer, Format == UIImage {
//  static let image = Snapshotting(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { layer in
//      return UIGraphicsImageRenderer(size: layer.bounds.size)
//        .image { ctx in layer.render(in: ctx.cgContext) }
//  }
//  )
//}
//
//extension Snapshotting where Value == UIView, Format == UIImage {
//    static let image: Snapshotting = Snapshotting(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { view in Snapshotting<CALayer, UIImage>.image.snapshot(view.layer) }
//  )
//}
//
//extension Snapshotting where Value == UIViewController, Format == UIImage {
//    static let image:Snapshotting = Snapshotting(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { vc in Snapshotting<UIView, UIImage>.image.snapshot(vc.view) }
//  )
//}


extension Snapshotting where Value == CALayer, Format == UIImage {
    static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { layer -> UIImage in
        return UIGraphicsImageRenderer(size: layer.bounds.size)
            .image { ctx in layer.render(in: ctx.cgContext) }
    }
}

extension Snapshotting where Value == UIView, Format == UIImage {
    static let image:Snapshotting<UIView, UIImage> = Snapshotting<CALayer, UIImage>.image.pullback { view in
        return view.layer
    }
}

extension Snapshotting where Value == UIViewController, Format == UIImage {
    static let image:Snapshotting<UIViewController, UIImage> = Snapshotting<UIView, UIImage>.image.pullback { vc in
        return vc.view
    }
}



extension Diffing where Value == String {
    static let lines = Diffing(
        diff: { (old, new) -> (String, [XCTAttachment])? in
            guard let difference = Diff.lines(old, new) else { return nil }
            return (
                "Diff:\n\(difference)",
                [XCTAttachment(string: difference)]
            )
    },
        from: { data in String(decoding: data, as: UTF8.self)},
        data:  { string in Data(string.utf8) })
}

extension Snapshotting where Value == String, Format == String {
    static let lines = Snapshotting(diffing: .lines,
                                    pathExtension: "txt",
                                    snapshot: { $0 }
    )
}


extension Snapshotting where Value == UIView, Format == String {
    static let recursiveDescription = Snapshotting(diffing: .lines, pathExtension: "txt") { view  in
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return (view.perform(Selector(("recursiveDescription"))).takeUnretainedValue() as! String)
          .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
    }
}


extension Snapshotting where Value == UIViewController, Format == String {
    static let recursiveDescription: Snapshotting<UIViewController,String> = Snapshotting<UIView, String>.recursiveDescription.pullback { vc -> UIView in
        return vc.view
    }
}

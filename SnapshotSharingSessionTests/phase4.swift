//
//  phase4.swift
//  SnapshotSharingSessionTests
//
//  Created by Ambar Septian on 20/02/20.
//  Copyright © 2020 Ambar Septian. All rights reserved.
//

import XCTest
@testable import SnapshotSharingSession

class CustomTableViewControllerTests: SnapshotTestCase {
    func testCustomTableViewControllerView() {
        let viewController = CustomTableViewController()
        assertSnapshot(matching: viewController.view, as: .image)
    }
}

struct Diffing<Value> {
    let diff: (Value, Value) -> (String, [XCTAttachment])?
    let from: (Data) -> Value
    let data: (Value) -> Data
}

struct Snapshotting<Value, Format> {
    let diffing: Diffing<Format>
    let pathExtension: String
    let snapshot: (Value) -> Format
    
    func pullback<NewValue>(_ f:@escaping(NewValue) -> Value) -> Snapshotting<NewValue, Format> {
        
        return Snapshotting<NewValue, Format>(
            diffing: self.diffing,
            pathExtension: self.pathExtension,
            snapshot: { a0 in self.snapshot(f(a0)) }
        )
    }
}

extension Snapshotting where Value == String, Format == String {
    static let lines = Snapshotting(diffing: .lines,
                                    pathExtension: "txt",
                                    snapshot: { $0 }
    )
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



extension Snapshotting where Value == CALayer, Format == UIImage {
    static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { layer -> UIImage in
        return UIGraphicsImageRenderer(size: layer.bounds.size)
            .image { ctx in layer.render(in: ctx.cgContext) }
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

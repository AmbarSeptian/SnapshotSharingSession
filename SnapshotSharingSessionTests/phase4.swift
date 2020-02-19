//
//  phase4.swift
//  SnapshotSharingSessionTests
//
//  Created by Ambar Septian on 20/02/20.
//  Copyright © 2020 Ambar Septian. All rights reserved.
//

import XCTest


struct Diffing<A> {
    let diff: (A, A) -> (String, [XCTAttachment])?
    let from: (Data) -> A
    let data: (A) -> Data
}

struct Snapshotting<A, Snapshot> {
    let diffing: Diffing<Snapshot>
    let pathExtension: String
    let snapshot: (A) -> Snapshot
    
    func pullback<A0>(_ f:@escaping(A0) -> A) -> Snapshotting<A0, Snapshot> {
        return Snapshotting<A0, Snapshot>(
            diffing: self.diffing,
            pathExtension: self.pathExtension,
            snapshot: { a0 in self.snapshot(f(a0)) }
        )
    }
}

extension Snapshotting where A == String, Snapshot == String {
    static let lines = Snapshotting(diffing: .lines,
                                    pathExtension: "txt",
                                    snapshot: { $0 }
    )
}


extension Diffing where A == UIImage {
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

extension Snapshotting where A == UIImage, Snapshot == UIImage {
    static let image = Snapshotting(diffing: .image,
                                    pathExtension: "png",
                                    snapshot: { $0 })
}



extension Snapshotting where A == CALayer, Snapshot == UIImage {
    static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { layer -> UIImage in
        return UIGraphicsImageRenderer(size: layer.bounds.size)
            .image { ctx in layer.render(in: ctx.cgContext) }
    }
}


extension Diffing where A == String {
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

extension Snapshotting where A == UIView, Snapshot == UIImage {
    static let image:Snapshotting<UIView, UIImage> = Snapshotting<CALayer, UIImage>.image.pullback { view in
        return view.layer
    }
}

extension Snapshotting where A == UIViewController, Snapshot == UIImage {
    static let image:Snapshotting<UIViewController, UIImage> = Snapshotting<UIView, UIImage>.image.pullback { vc in
        return vc.view
    }
}


extension Snapshotting where A == UIView, Snapshot == String {
    static let recursiveDescription = Snapshotting(diffing: .lines, pathExtension: "txt") { view  in
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return (view.perform(Selector(("recursiveDescription"))).takeUnretainedValue() as! String)
          .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
    }
}


extension Snapshotting where A == UIViewController, Snapshot == String {
    static let recursiveDescription: Snapshotting<UIViewController,String> = Snapshotting<UIView, String>.recursiveDescription.pullback { vc -> UIView in
        return vc.view
    }
}
